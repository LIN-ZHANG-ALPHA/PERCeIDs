function Unew = regul_graph(A,F,step,lambda)

% graph Laplacian
L = full(sgwt_laplacian(A,'opt','normalized'));

% Regularization on graph by iterations
Uold = F;
Unew = Uold-step*( -(F-Uold) + (lambda*L*Uold')' );
while norm(Unew-Uold,'fro') > 10^(-4)
    Uold = Unew;
    Unew = Uold-step*( -(F-Uold) + (lambda*L*Uold')' );
end

% Directly computing the closed-form solution
% Unew = 1/lambda*(L+1/lambda*eye(size(A,1)))^(-1)*F';
% Unew = Unew';