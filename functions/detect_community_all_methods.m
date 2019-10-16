

function  [Fac_PCD_L1,Fac_LARC,Fac_NTF,PCD_L1_exta] =  detect_community_all_methods(W_tensor,opts,opts_pcd,ops_larc,ops_ntf)
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


%%
ntimes_pcd = opts.pcd_times;
ntimes_baselines = opts.baseline_times;
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

%% PCD-L2
% % rng(185);
% % rng('shuffle')
% opts_pcd.Hinit    = Hinit;
% %opts_pcd.Pmax     = 30;
% opts_pcd.norm_method    = 'l2_norm'; %'cvx';, L1_ norm, L2_norm
% % opts_pcd.max_iter       = 200;
% opts_pcd.Penalty_type   = 'square'; % 'linear';
% opts.halting_Thr         = 1e-6;
% tic
% [Fac_PCD_L2,~,~,~,~] = PERCeIDs(W_tensor,opts.K,opts_pcd);
% for kk = 2:ntimes_pcd
%     [Fac_PCD_L2tmp,~,~,~,~] = PERCeIDs(W_tensor,opts.K,opts_pcd);
%     Fac_PCD_L2{1} =  Fac_PCD_L2{1} + Fac_PCD_L2tmp{1};
%     Fac_PCD_L2{2} =  Fac_PCD_L2{2} + Fac_PCD_L2tmp{2};
%     Fac_PCD_L2{3} =  Fac_PCD_L2{3} + Fac_PCD_L2tmp{3};
% end
% 
% Fac_PCD_L2{1}  =   Fac_PCD_L2{1} ./ntimes_pcd;
% Fac_PCD_L2{1}  =   Fac_PCD_L2{2} ./ntimes_pcd;
% Fac_PCD_L2{1}  =   Fac_PCD_L2{2} ./ntimes_pcd;
% toc

%% Larc
ops_larc.Hinit = Hinit;
ops_larc.constraint{1} = 'nonnegative';
ops_larc.constraint{2} = 'nonnegative';
ops_larc.constraint{3} = 'fln';
% ops_larc.la=1; %ops.la=0.0001;
% ops_larc.lb=1;
%rng(185);
% rng('shuffle')
% num_rand =  1;


tic
[Fac_LARC,~] = LARC(W_tensor,opts.K, ops_larc);
for i = 2: ntimes_baselines
    [Fac_LARC_temp,~] = LARC(W_tensor,opts.K, ops_larc);
    Fac_LARC{1} =  Fac_LARC_temp{1} + Fac_LARC{1} ;
    Fac_LARC{2} =  Fac_LARC_temp{2} + Fac_LARC{2} ;
    Fac_LARC{3} =  Fac_LARC_temp{3} + Fac_LARC{3} ;
end

Fac_LARC{1} =  Fac_LARC{1}./ntimes_baselines;
Fac_LARC{2} =  Fac_LARC{2}./ntimes_baselines;
Fac_LARC{3} =  Fac_LARC{3}./ntimes_baselines;

toc

%% NTF  tensor decomposition
ops_ntf.constraint{1} = 'nonnegative';
ops_ntf.constraint{2} = 'nonnegative';
ops_ntf.constraint{3} = 'nonnegative';
ops_ntf.noReg         = 1;
% ops_ntf.la            = 0.0001;
% ops_ntf.lb            = 0.0001;
% rng(185);
ops_ntf.Hinit  =  Hinit;

tic
[Fac_NTF,~] = LARC(W_tensor,opts.K, ops_ntf);
for i = 2:ntimes_baselines
    [Fac_NTF_temp,~] = LARC(W_tensor,opts.K, ops_ntf);
    
    Fac_NTF{1} =  Fac_NTF_temp{1} + Fac_NTF{1} ;
    Fac_NTF{2} =  Fac_NTF_temp{2} + Fac_NTF{2} ;
    Fac_NTF{3} =  Fac_NTF_temp{3} + Fac_NTF{3} ;
end
Fac_NTF{1} =  Fac_NTF{1}./ntimes_baselines;
Fac_NTF{2} =  Fac_NTF{2}./ntimes_baselines;
Fac_NTF{3} =  Fac_NTF{3}./ntimes_baselines;
toc

%%  NNMF
% rng(185);
% AA   = sum(W_tensor,3); % aggregate network
% tic
%
% [W,H] = nnmf(AA,opts_syndata.K);
% for i = 2:num_rand
%     [W_temp,H_temp] = nnmf(AA,opts_syndata.K);
%     W = W + W_temp;
%     H = H + H_temp;
% end
% W = W./num_rand;
% H = H./num_rand;
%
% Fac_NNMF{1} = W;% ./norm(W);
% Fac_NNMF{2} = W;%./norm(W);
% Fac_NNMF{3} = H';% ./norm(H);
toc

end