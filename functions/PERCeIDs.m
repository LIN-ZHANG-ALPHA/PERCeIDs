
function [Factor,Y,O,Phi,Energ_period] = PERCeIDs(W_tensor,K,opts)
% function [Factor,Y,O,Phi,Energ_period] = PCD2019(W_tensor,K,opts)
% function [U,X,Y,O,Phi,Periods] = PCD(W_tensor,opts)
% periodic community detection (PCD)
% min_{}  ||W- [U,X]||_F^2 +  lambda_0* || X- \Phi*H -O||_F^2
%          + lambda_1* || H.*Y||_1 + lambda_2* || O||_1
% input:
%       K       : number of communities
%       W_tensor:  m x m * T( tensot T lenght of signal; m: number of nodes in network, also communit'activity is a signal instance)
%       opts: parameters
%               H        : penalty function
%               lambda_0 : lambda_0* || X- \Phi*Y -O||_F^2
%               lambda_1 : lambda_1* || H*Y||_1
%               lambda_2 : lambda_2* || O||_1
%                max_iter: max iteration
% Output:
%       U: community matrix   (m x K)
%       X: community activity (T x K)
%       Y: periods            (N x K)
%       O: burst              (K x T)
%       P: \Phi*Y;

% @LINZHANG @04/02/2019



%% parameter settings

T     = size(W_tensor,3); % number of Time length? which is signal length
m     = size(W_tensor,1); % number of nodes

if ~isfield(opts, 'lambda_0'),             opts.lambda_0           = 1; end  % cost function
if ~isfield(opts, 'lambda_1'),             opts.lambda_1           = 1; end  % sparse period
if ~isfield(opts, 'lambda_2'),             opts.lambda_2           = .1; end % outlier sparse
if ~isfield(opts, 'max_iter'),               opts.max_iter            = 200; end  %
if ~isfield(opts, 'max_inner_iter'),     opts.max_inner_iter   = 100; end         %  opts.max_inner_iter   = 100;
if ~isfield(opts, 'halting_Thr'),           opts.halting_Thr         = 1e-6; end  %
if ~isfield(opts, 'Pmax'),                   opts.Pmax                 = 100; end %
if ~isfield(opts, 'Dictionary_type'),    opts.Dictionary_type  = 'Ramanujan'; end % Type of the dictionary
if ~isfield(opts, 'norm_method'),      opts.norm_method        = 'l1_norm'; end   %l1/ l2 norm
if ~isfield(opts, 'Penalty_type'),        opts.Penalty_type    = 'square';  end   %l1/ l2 norm


lambda_0          =  opts.lambda_0;
lambda_1          =  opts.lambda_1;
lambda_2          =  opts.lambda_2;
max_iter           =  opts.max_iter;
max_inner_iter  =  opts.max_inner_iter;
halting_Thr        = opts.halting_Thr;
Pmax                = opts.Pmax;
Dictionary_type = opts. Dictionary_type;
norm_method   = opts.norm_method;
Penalty_type     = opts.Penalty_type;

% initilzation of Tensor factors
if ~isfield(opts,'Hinit')
    Hinit{1} = rand( N, K );
    Hinit{2} = rand( N, K );
    Hinit{3} = rand( T, K );
    for d = 1:3
        Hinit{d} = Hinit{d} / diag( sqrt( sum( Hinit{d}.^2 ) ) );
    end
    opts.Hinit = Hinit;
end

GG = cell( 3, 1 );
for d = 1:3
    GG{d} = opts.Hinit{d}'*opts.Hinit{d};
end
%% initialization
% +++++++++++++++++ get mode-i matrices of tenosr
% Wm  = cell( ndims(W_tensor), 1 );
% for d = 3% 1:ndims(W_tensor)
%     temp  = tenmat(W_tensor,d);
%     Wm{d} = temp.data; % the matrix that is the unfolded tensor;; NOT transposed here
% end

Wm= get_tensor_mode(W_tensor);

% ++++++++++++++++++define NPM dictionary
Phi = Create_Dictionary(Pmax,T,Dictionary_type);
% for i=1:size(Phi,2)      % normaliaztion if dont want to penalty
%     Phi(:,i) = Phi(:,i)./norm(Phi(:,i));
% end

%+++++++++++++++ define H penalty function
[periods,pv]  =  get_period_penalty(Pmax,Penalty_type);
H                  =  diag(pv);
H_inv            =  diag(1./pv); % inverse of diagnal matrix

% ++++++++++++++++++++++++initalize tensor factor
% [Hinit{1} ,Hinit{2} ,Hinit{3} ] = cp3_init(W_tensor,K,'dtld');
X          =  opts.Hinit{3};     % X
U{1}    =  opts.Hinit{1} ;    % U1
U{2}    =  opts.Hinit{2} ;    % U2
O          =  rand( T, K ); O = O / diag( sqrt( sum( O.^2 ) ) );%;zeros(T,K);   % outlier
Y           =  rand(size(Phi,2),K); Y = Y / diag( sqrt( sum( Y.^2 ) ) );% zeros(size(Phi,2),K); % period sparse coefficients

% O = zeros(T,K);
% Y  =  zeros(size(Phi,2),K);
%% main loop from here
for iter =  1: max_iter
    
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % ++++++++++++++++++ update U:    ++++++++++++++++++++++
    for i = 1:2 % ONLY U1 and U2
        % W_cur      = Wm{i};          % current mode matrix for tensor
        U_not_cur  = abs(i-1)*U{1} + abs(i-2)*U{2}; % When i=1, take U2, vice versa
        U_is_cur     = abs(i-2)*U{1}+ abs(i-1)*U{2};
        % H_tmp{1} = U{2}; H_tmp{2} = U{1}; H_tmp{3} = X;
        % U{i} =  update_U_sptensor(W_tensor,Wm{i}, X, U_is_cur,U_not_cur, max_inner_iter, K,i);
        [U{i},GG]           = update_U(W_tensor,Wm{i},X,U_is_cur,U_not_cur,max_inner_iter,K,GG,i);
    end
    
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % ++++++++++++++++++ update X:    ++++++++++++++++++++++
    W_3   = Wm{3};          % mode-3 of tensor on temporal dimension
    [X,GG]    = update_X(W_tensor,W_3,X,U{1},U{2},Y,O,Phi,lambda_0,max_inner_iter,K,GG);
    
    
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % ++++++++++++++++++ update Y:    ++++++++++++++++++++++
    F =  X - O;
    Y =  update_Y(F,Phi, H_inv, lambda_0,lambda_1,norm_method);
    
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % ++++++++++++++++++ update O:    ++++++++++++++++++++++
    Z =  X - Phi * Y;
    O =  max(abs(Z) - 0.5*lambda_2/lambda_0,0).*sign(Z);
    
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % ++++++++++++++++++ Normalization to avoid overflow, LEARN from CP decomposition
%     normU1     = sqrt(sum(U{1}.*U{1})); %sqrt(sum(A.*A));  % Frobenius norm of each column of A
%     normU2     = sqrt(sum(U{2}.*U{2}));
%     normX       = sqrt(sum(X.*X));
%     prod_norm = normU1.*normU2.*normX;
%     Scale_mat   = diag(prod_norm.^(1/3));
%     % equal repartition of power of each rank-1 tensor over the 3 vectors:
%     U{1}      = U{1}*diag(1./normU1)*Scale_mat;
%     U{2}      = U{2}*diag(1./normU2)*Scale_mat;
%     X            = X*diag(1./normX)*Scale_mat;
%     O           = O*diag(1./normX)*Scale_mat;

    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % ++++++++++++++++++ stop condition check ++++++++++++++
    obj = get_object(W_tensor,Wm{1},U{1},U{2}, X,Phi,Y, H,O, lambda_0,lambda_1,lambda_2);
    
    if iter > 1
        res_obj  = abs(obj - obj_old)/obj_old;
        res_O    = max(max(abs(O - O_old)))  ;
        res_U1   = max(max(abs(U{1} - U_1_old)))  ;
        res_U2   = max(max(abs(U{2} - U_2_old)))  ;
        res_X    = max(max(abs(X - X_old)))  ;
        if res_obj < halting_Thr && res_O < halting_Thr && res_U1 < halting_Thr && res_U2 < halting_Thr && res_X < halting_Thr
            break
        end
        
        if mod(iter,20) ==0
            disp(['Iter:',num2str(iter),'::','obj_res = ',num2str(abs(res_obj)),';', 'obj_U= ',num2str(res_U1),';','obj_O= ',num2str(res_O),';','obj_X= ',num2str(res_X)]);
        end
        
    end
    
    
    U_1_old   = U{1} ;
    U_2_old   = U{2} ;
    X_old      = X  ;
    O_old     = O  ;
    obj_old   = obj;
end

%% iterations done
%%
%% normalizing the factor matrices.

mu1 = max(U{1}); U{1} = U{1}./mu1;
mu2 = max(U{2}); U{2} = U{2}./mu2;

scale         = mu1.*mu2;
Factor{3} = X.*scale;
Factor{1} = (U{1}+U{2})/2;
Factor{2} = (U{1}+U{2})/2;

% [dumb, membership]    = sort(U, 'descend');  % l21 norm
% Periods =  get_period(periods,Y);

%% get energy of each period in temporal profile
[m1,n1] = size(Y);
%Energ_period = zeros();
for ll =  1: n1
    s = Y(:,ll);
    energy_s = 0.*[1:Pmax];
    current_index_end = 0;
    for i=1:Pmax
        k_orig = 1:i;k=k_orig(gcd(k_orig,i)==1);
        current_index_start = current_index_end + 1;
        current_index_end = current_index_end + size(k,2);
        for j=current_index_start:current_index_end
            energy_s(i) = energy_s(i)+((abs(s(j)))^2);
        end
    end
    energy_s(1)         = 0;
    Energ_period(:,ll) =  energy_s;
    
end

end




