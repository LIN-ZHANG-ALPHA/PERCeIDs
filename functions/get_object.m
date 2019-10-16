
function obj = get_object(T,W,U1,U2, X,Phi,Y,H, O, lambda_0,lambda_1,lambda_2)
% W is one of the mode
% tensor_obj = norm(W - U1*kr(X,U2)', 'fro')^2 ;
% tensor_obj = norm(W - U1*krb(X,U2)', 'fro')^2 ;
if  ~isa(W,'sptensor')
    tensor_obj = norm(W - U1*khatrirao(X,U2)', 'fro')^2 ;
else
    G{1}=U1; G{2}=U2;G{3} =X;
    tensor_obj = norm(W)^2+norm(U1)^2+norm(U2)^2+norm(X)-2*innerprod(T,ktensor(G));% norm(W - U1*sparse_khatrirao(sparse(X),sparse(U2))', 'fro')^2 ; too large
end

obj        = 0.5* tensor_obj + lambda_0 * norm(X - Phi*Y -O,'fro')^2 ...
    + lambda_1* norm(H*Y,1) +lambda_2 * norm(O,1);
end
