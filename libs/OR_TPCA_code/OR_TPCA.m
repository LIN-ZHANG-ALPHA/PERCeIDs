
function [L,E, L_rank]=OR_TPCA(X,max_iter,tol)
[n1,n2,n3]=size(X);


E = zeros(n1,n2,n3);
L=E;
J=E;
lambda=1/(sqrt(log(n2)));

beta = 1e-6;
max_beta = 1e+8;
% tol = 1e-8;
rho = 1.1;
iter = 0;
% max_iter = 500;
Temp=X;
while iter < max_iter
    iter = iter+1;
    %% update L
    R = Temp-E;
    Lpre = L;
    [L,L_nuc,L_rank,LU] = prox_tnn(R,1/beta);
    %% update E
    Q    = Temp-L;
    Epre = E;
    [E, sparsity, supp_set, l21 ] = prox_l21( Q, lambda/beta );
    
    %% check convergence
    leq = X-L-E;
    leqm = max(abs(leq(:)));
    difX = max(abs(L(:)-Lpre(:)));
    difE = max(abs(E(:)-Epre(:)));
    err = max([leqm,difX,difE]);
    if mod(iter,20)==0
        fprintf('iter = %d, obj = %.3f, err = %.8f, beta=%.2f, rankL = %d, sparsity=%d\n'...
            , iter,L_nuc+l21*beta,err,beta,L_rank,sparsity);
    end
    if err < tol
        break;
    end
    %% update Lagrange multiplier and  penalty parameter beta
    J = J + beta*leq;
    beta = min(beta*rho,max_beta);
    Temp=X+J/beta;
end
end