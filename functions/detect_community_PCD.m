



function  [Fac_PCD_L1,PCD_L1_exta] =  detect_community_PCD(W_tensor,opts,opts_pcd)
%function  [Fac_PCD_L1,Fac_PCD_L2,Fac_LARC,Fac_NTF] =  detect_community_all_methods(W_tensor,opts,opts_pcd,ops_larc,ops_ntf)
% function  [Fac_PCD_L1,Fac_PCD_L2,Fac_LARC,Fac_NTF,Fac_NNMF] =  detect_community_all_methods(W_tensor,opts_syndata,opts)

if nargin < 3
    opts_pcd = [];
end

if nargin < 4
    ops_larc  = [];
end
if nargin < 5
    ops_ntf    = [];
end


if ~isfield(opts, 'pcd_times'),             opts.pcd_times         = 1; end  
if ~isfield(opts, 'baseline_times'),      opts.baseline_times  = 1; end  

if ~isfield(ops_larc, 'la'),             ops_larc.la=.01;     end  
if ~isfield(ops_larc, 'lb'),             ops_larc.lb=.01;     end  

if ~isfield(ops_ntf, 'la'),             ops_ntf.la   = 0.0001;   end  
if ~isfield(ops_ntf, 'lb'),             ops_ntf.lb  = 0.0001;   end  

if ~isfield(opts_pcd, 'Penalty_type'),           opts_pcd.Penalty_type      = 'square';   end  



ntimes_pcd = opts.pcd_times;

%%


sz=size(W_tensor);
N = sz(1);
T = sz(3);

% rng(110);
% rng('default')

Hinit{1} = rand( N, opts.K ); % .*( rand( N, opts_syndata.K ) < .5 );  % .*( rand( n, k ) < .5 );
Hinit{2} = rand( N, opts.K );
Hinit{3} = rand( T, opts.K );
for d = 1:3
    Hinit{d} = Hinit{d} / diag( sqrt( sum( Hinit{d}.^2 ) ) );
end

%% PCD -L1
% rng(100);
% rng('default')
% rng('shuffle')
opts_pcd.Hinit    = Hinit;
% opts_pcd.Pmax     = 30;
opts_pcd.norm_method    = 'l1_norm'; %'cvx';, L1_ norm, L2_norm
% opts_pcd.max_iter            = 200;
% opts_pcd.Penalty_type      = 'linear'; % 'linear';
% opts.halting_Thr         = 1e-6;
tic
[Fac_PCD_L1,PCD_L1_exta.Y_L1,PCD_L1_exta.O_L1,PCD_L1_exta.Phi_L1,PCD_L1_exta.Energ_period_L1] = PERCeIDs(W_tensor,opts.K,opts_pcd);

% Fac_PCD_L1 =  Fac_PCD_L1_01;
% ntimes =1;
for jj= 2:ntimes_pcd
    [Fac_PCD_L1_tmp,Y_L2_tmp,O_L2_tmp,Phi_L2_tmp,Energ_period_L2_tmp] = PERCeIDs(W_tensor,opts.K,opts_pcd);
    Fac_PCD_L1{1} =  Fac_PCD_L1{1} + Fac_PCD_L1_tmp{1};
    Fac_PCD_L1{2} =  Fac_PCD_L1{2} + Fac_PCD_L1_tmp{2};
    Fac_PCD_L1{3} =  Fac_PCD_L1{3} + Fac_PCD_L1_tmp{3};
end
Fac_PCD_L1{1}  =   Fac_PCD_L1{1} ./ntimes_pcd;
Fac_PCD_L1{1}  =   Fac_PCD_L1{2} ./ntimes_pcd;
Fac_PCD_L1{1}  =   Fac_PCD_L1{2} ./ntimes_pcd;
toc







end