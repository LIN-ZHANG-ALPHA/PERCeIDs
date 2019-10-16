
function [X, GG] = update_X(W_tensor, W_3,X,U1,U2,Y,O,Phi,lambda_0,max_inner_iter,K,GG)

% argmin_{X, X_grave} 1/2*||W_3^T - V*X_grave||_F^2 + lambda_0 ||X- Phi*Y-O||
% s.t. X = X_grave^T, X>=0
% use AOADMM
% @LINZHANG @04/03/2019

tol            =  1e-4;
% tol            =  1e-4;


Temp       = Phi * Y + O;

if  isa(W_3,'sptensor') 
    % k     = size(U1,2);
    d     = 3; % this is for the 3rd dimension ONLY.
    VTV= ones(K,K); prod = [ 1:d-1, d+1:length(GG) ];
    for dd = prod
        VTV = VTV .* GG{dd};
    end
    
    rho        = min(1e-3,trace(VTV)/K);
    
    LX         = chol( VTV + rho*eye(K), 'lower' );
    VtV_inv = LX^(-1);
    
    %    VtV_inv = (VTV + rho*eye(K)+eps)^(-1);
    
    H{1} =  U1;
    H{2} =  U2;
    H{3} = X;
    VW3 = mttkrp( W_tensor, H, 3)'; %3 for the 3rd dim ONLY
    
% elseif isa(W_3,'sptensor') &&size(W_3,1)<= 200
%     
%      V             = khatrirao(U1,U2);
%     %  V            = sparse_khatrirao(sparse(U1), sparse(U2));
%     VTV         = V'*V;
%     rho          = trace(VTV)/K;%rho          = trace(V'*V)/K;
%     VtV_inv    = (VTV + rho* eye(K)+eps)^(-1);  % for pre-compute
%     
%     VW3        = V'* double(W_3)';                   % pre-compute   
%     
else
    V             = khatrirao(U1,U2);
    %  V            = sparse_khatrirao(sparse(U1), sparse(U2));
    VTV         = V'*V;
    rho          = trace(VTV)/K;%rho          = trace(V'*V)/K;
    VtV_inv    = (VTV + rho* eye(K)+eps)^(-1);  % for pre-compute
    
    VW3        = V'* W_3';                   % pre-compute
end


%%
S                = zeros(size(VW3')); % initialize S
for iter_X  =  1: max_inner_iter
    % X_hat =  (V'*V)^(-1) * (V'* W_3 + rho * (X+S)');
    X_grave =  VtV_inv * (VW3 + rho * (X+S)');
    X           =  (2*lambda_0*Temp  + rho*(X_grave' - S))/(2*lambda_0 + rho);
    X           =  max(X,0); % do a zero threshold for X for non-negativity
    S           =  S + (X - X_grave');
    if iter_X > 1
        rX = norm(X-X_grave','fro')/norm(X,'fro');  % relative primal residual
        sX = norm(X-X_old,'fro')/norm(S,'fro')   ;  % the relative dual residual
        
        if rX < tol && sX < tol
            break
        end
    end
    X_old    = X;
end

if isa(W_3,'sptensor')
    GG{3} = X'*X;
else
    GG = [];
end
