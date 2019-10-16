 
function  [Y,Energ_period] = get_period_NPM(X,opts)
 
if ~isfield(opts, 'Pmax'),           opts.Pmax           = 20; end
if ~isfield(opts, 'Dictionary_type'),   opts.Dictionary_type   = 'Ramanujan'; end
if ~isfield(opts, 'Penalty_type'),   opts.Penalty_type   = 'square'; end
if ~isfield(opts, 'lambda'),   opts.lambda   = 0.1; end
if ~isfield(opts, 'visual'),         opts.visual   = 0; end
 
 
 
% X: signal, Txk
% Pmax: max periods
%
 
%%
 
T =  size(X,1);
 
Phi = Create_Dictionary(opts.Pmax,T,opts.Dictionary_type);
 
[periods,pv]  =  get_period_penalty(opts.Pmax,opts.Penalty_type);
H_inv         =  diag(1./pv); % inverse of diagnal matrix
 
 
T =  lasso(Phi*H_inv, X,opts.lambda);
Y =  H_inv * T;
 
 
%% get energy of each period in temporal profile
[m1,n1] = size(Y);
%Energ_period = zeros();
for ll =  1: n1
    s = Y(:,ll);
    energy_s = 0.*[1:opts.Pmax];
    current_index_end = 0;
    for i=1:opts.Pmax
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
 
if opts.visual ==1
    plot_pcd_period(Energ_period,Y, opts.Pmax)
end