function [f,g] = comeig2_lbfgs(q,N,M,L,D,P,alpha,beta)
% compute derivative with respect to P^(-1), which is used in the L-BFGS
% algorithm (treat P^(-1) as independent Q)
Q = reshape(q',N,N);
f = 0;

for i = 1:M
tmp = 1/2*norm((L(:,:,i) - P*D(:,:,i)*Q),'fro')^2;
f = f + tmp;
end

f = f + 1/2*alpha*norm(P,'fro')^2 + 1/2*alpha*norm(Q,'fro')^2 + 1/2*beta*norm(P*Q-eye(N),'fro')^2;

if nargout > 1
    G = zeros(size(Q));
    for i = 1:M
        tmp = (-1)*(L(:,:,i) - P*D(:,:,i)*Q)*P*D(:,:,i);
        G = G + tmp;
    end
    
    G = G + alpha*Q + beta*(P*Q-eye(N))*P;
    g = G(:)';
end