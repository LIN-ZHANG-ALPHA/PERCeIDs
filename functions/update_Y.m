

function Y =  update_Y(F,Phi, H_inv, lambda_0,lambda_1,method)

% min_T ||F-(Phi*H_inv)* T||_F^2 + lambda1/lambda0 ||T||_{L1 OR L2}
% L1norm: lasso
% L2norm: closed form solution
% if nargin < 6
%     method = 'l1_norm';
% end

switch method
    case 'l1_norm'
        %T =  lasso(F, Phi*H_inv, lambda_1/lambda_0); % default: tol=1e-5, max_it=100
        %       Y =  H_inv * T';               % T = H*Y; here T from lasso is transposed
        T =  lasso(Phi*H_inv, F,lambda_1/lambda_0); % default: tol=1e-5, max_it=100
        Y =  H_inv * T;              
    case 'l2_norm'
        % HAS closed form solution
        % D = diag((1./penalty_vector).^2);
        % PP = D*A'*inv(A*D*A');
        D   =  H_inv.^2;
        PP  = D * Phi' * inv(Phi *D*Phi' + lambda_1/lambda_0 * eye(size(Phi,1)) ) ;
        Y    = PP*F;
        
    case 'ridge'
        % D   =  H_inv.^2;
        
        PP = inv(H_inv*Phi'*Phi*H_inv + lambda_1/lambda_0 * eye(size(H_inv)))*H_inv*Phi';
        Y    =  PP * F;
        
    case 'cvx'
        [m,n]               = size(F);
        penalty_vector =  diag(1./H_inv);
        for i = 1:n
            x =  F(:,i);
            cvx_begin quiet % no display
            cvx_precision low
            variable s(size(Phi,2))
            minimize(norm(penalty_vector.*s,1))
            subject to
            x==Phi*s;
            cvx_end
            
            Y(:,i)  = s;
        end
    otherwise
        disp('specify norm_method ')
end

