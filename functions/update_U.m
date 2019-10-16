
function [U,GG] =  update_U(W_tensor, W, X, U, U_not_cur, max_inner_iter, K,GG,d)

% argmin_{U,U_grave} 1/2 * ||W^T - R*U_grave||_F^2 + D(U)
% s.t U = U_grave^T, U >= 0
% @LINZHANG @04/03/2019

tol =  1e-4;


if  isa(W,'sptensor')
    % this is an approximation
    %  k     = size(U,2);
    RTR = ones(K,K); prod = [ 1:d-1, d+1:length(GG) ];
    for dd = prod
        RTR = RTR .* GG{dd};
    end
    eta        = min(1e-3,trace(RTR)/K);
    LU        = chol( RTR + eta*eye(K), 'lower' );
    RtR_inv = LU^(-1);
    
    %    RtR_inv = (RTR + eta*eye(K)+eps)^(-1);
    
    H{1} =  U;
    H{2} =  U_not_cur;
    H{3} = X;
    RtW_cur_t = mttkrp( W_tensor, H, 1)'; % FIX 1 HERE, as U/U_not_cur are keep alternating.

% elseif isa(W,'sptensor')&& size(W,1)<= 200
%         R     = khatrirao(X,U_not_cur);
%     RTR = R'*R;
%     eta  = trace(RTR)/K;
%     
%     RtR_inv       = (RTR + eta * eye(K)+eps)^(-1); % pre-compute
%     RtW_cur_t  =  R'*double(W)';                % pre-compute
    
else 
    R     = khatrirao(X,U_not_cur);
    RTR = R'*R;
    eta  = trace(RTR)/K;
    
    RtR_inv       = (RTR + eta * eye(K)+eps)^(-1); % pre-compute
    RtW_cur_t  = R'*W';                  % pre-compute
end

%% 
Q                = zeros(size(U_not_cur));            % initial Q
for iter_U  =  1: max_inner_iter
    % U_grave = (R'*R + eta * eye(n))^(-1) * (R'*W_cur' + eta *(U_cur + Q));
    U_grave = RtR_inv * (RtW_cur_t + eta *(U + Q)');
    U       = max(U_grave' - Q, 0); % non negativity of U
    Q       = Q  + U - U_grave';
    
    % stop condition check
    if iter_U > 1
        rU = norm(U - U_grave','fro')/norm(U,'fro'); % relative primal residual
        sU = norm(U - U_old,'fro')/norm(Q,'fro');  % the relative dual residual
        
        if  rU < tol && sU < tol
            break
        end
    end
    
    U_old        = U;
end


if isa(W,'sptensor')
    GG{d} = U'*U;
else
    GG = [];
end
