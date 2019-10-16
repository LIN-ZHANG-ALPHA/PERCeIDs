function [f,g] = comeig_lbfgs(p,N,M,L,D,Q,alpha,beta)
% compute derivative with respect to P, which is used in the L-BFGS
% algorithm
P = reshape(p',N,N);
f = 0;

for i = 1:M
tmp = 1/2*norm((L(:,:,i) - P*D(:,:,i)*Q),'fro')^2;
f = f + tmp;
end

f = f + 1/2*alpha*norm(P,'fro')^2 + 1/2*alpha*norm(Q,'fro')^2 + 1/2*beta*norm(P*Q-eye(N),'fro')^2;

if nargout > 1
    G = zeros(size(P));
    for i = 1:M
        tmp = (-1)*(L(:,:,i) - P*D(:,:,i)*Q)*Q'*D(:,:,i);
        G = G + tmp;
    end
    
    G = G + alpha*P + beta*(P*Q-eye(N))*Q';
    g = G(:)';
end