 
 
 
function [DIV_order,DIV_best,NMI]  = evaluation_single(Factor,opts)
% function [DIV_order,DIV_best]  = evaluation(Fac_PCD_L1,Fac_PCD_L2,Fac_LARC,Fac_NTF,Fac_NNMF,groundtruth,opts)
 DIV_order = [];
DIV_best = [];
 NMI = [];
%  metric
%  NormalizedMutual  Information  (NMI)
%  Average F1 score
%  Jansen-Shannon divergence (DIV)
 
if ~isfield(opts, 'NMI'),     opts.NMI          = 0; end %
if ~isfield(opts, 'F1'),      opts.F1           = 0; end %
if ~isfield(opts, 'JSDiv'),     opts.JSDiv          = 0; end %
if ~isfield(opts, 'threshold'),     opts.comm_threshold     = 0.2; end %
 
threshold =    opts.comm_threshold ;
 
 
% get the detected results
commu_detect.C  = normc(Factor{1});
% commu_pcd_L2.C  = normc(Fac_PCD_L2{1});
% commu_larc.C        = normc(Fac_LARC{1});
% commu_ntf.C         = normc(Fac_NTF{1});
% % commu_nnmf.C = normc(Fac_NNMF{1});
 
C_GT                = double(logical(opts.GT));
groundtruth.C       = C_GT; %normc(C_GT);
 
 
 
% measure w.r.t GT
if opts.JSDiv == 1
    
    [order_best, score_best]    = evalMatchFast(commu_detect, groundtruth,1);
%     [order_pcd_L2, best_pcd_L2]    = evalMatchFast(commu_pcd_L2, groundtruth,1);
%     [order_larc, best_larc]  = evalMatchFast(commu_larc, groundtruth,1);
%     [order_ntf, best_ntf]    = evalMatchFast(commu_ntf, groundtruth,1);
    % [order_nnmf, best_nnmf]  = evalMatch(commu_nnmf, groundtruth);
    
    DIV_order.order = order_best;
%     DIV_order.pcd_L2 = order_pcd_L2;
%     DIV_order.larc = order_larc;
%     DIV_order.ntf = order_ntf;
    % DIV_order.nnmf = order_nnmf;
    
    DIV_best.score =  score_best;
%     DIV_best.pcd_L2 =  best_pcd_L2;
%     DIV_best.larc   =  best_larc;
%     DIV_best.ntf    =  best_ntf;
    % DIV_best.nnmf   =  best_nnmf;
end
 
 
 
if opts.NMI == 1
    K = size(C_GT,2); % number of communities
    
    C_factor_1 = Factor{1};%(:,order_pcd_L1);
%     C_pcd_L2 = Fac_PCD_L2{1};%(:,order_pcd_L2);
%     C_larc   = Fac_LARC{1};%(:,order_larc);
%     C_ntf    = Fac_NTF{1};% (:,order_ntf);
    
    C_factor_1(C_factor_1>threshold) =1;  C_factor_1(C_factor_1<=threshold)=0;  % thresholding
    C_factor_1_cell = arrayfun(@(t) find(C_factor_1(:,t)),1:K,'UniformOutput',false);
    
%     C_pcd_L2(C_pcd_L2>threshold) =1; C_pcd_L2(C_pcd_L2<=threshold)=0;
%     C_pcd_L2_cell = arrayfun(@(t) find(C_pcd_L2(:,t)),1:K,'UniformOutput',false);
%     
%     C_larc(C_larc>threshold) =1;  C_larc(C_larc<=threshold)=0;
%     C_larc_cell = arrayfun(@(t) find(C_larc(:,t)),1:K,'UniformOutput',false);
%     
%     
%     C_ntf(C_ntf>threshold) =1; C_ntf(C_ntf<=threshold)=0;
%     C_ntf_cell = arrayfun(@(t) find(C_ntf(:,t)),1:K,'UniformOutput',false);
%     
%     
    C_GT(C_GT>threshold)=1; C_GT(C_GT<=threshold)=0;
    C_GT_cell = arrayfun(@(t) find(C_GT(:,t)),1:K,'UniformOutput',false);
    
    N          = size(C_GT,1); % number of nodes in the network
    NMI = gnmi(C_factor_1_cell, C_GT_cell, N);
%     NMI.pcd_L2 = gnmi(C_pcd_L2_cell, C_GT_cell, N);
%     NMI.larc   = gnmi(C_larc_cell, C_GT_cell, N);
%     NMI.ntf    = gnmi(C_ntf_cell, C_GT_cell, N);
end
 
 
 
 
 
 
 
 