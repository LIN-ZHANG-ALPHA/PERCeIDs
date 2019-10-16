



function [DIV_order,DIV_best,NMI]  = evaluation_PCD(Fac_PCD_L1,opts)
% function [DIV_order,DIV_best,NMI]  = evaluation(Fac_PCD_L1,Fac_PCD_L2,Fac_LARC,Fac_NTF,opts)
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
commu_pcd_L1.C  = normc(Fac_PCD_L1{1});



C_GT                     = double(logical(opts.GT));
groundtruth.C       = C_GT; %normc(C_GT);



% measure w.r.t GT
if opts.JSDiv == 1
    
    [order_pcd_L1, best_pcd_L1]    = evalMatchFast(commu_pcd_L1, groundtruth,1);

%     
    DIV_order.pcd_L1 = order_pcd_L1;

    
    DIV_best.pcd_L1 =  best_pcd_L1;

end



if opts.NMI == 1
    K = size(C_GT,2); % number of communities
    
    C_pcd_L1 = Fac_PCD_L1{1}(:,order_pcd_L1);

    
    C_pcd_L1(C_pcd_L1>threshold) =1;  C_pcd_L1(C_pcd_L1<=threshold)=0;  % thresholding
    C_pcd_L1_cell = arrayfun(@(t) find(C_pcd_L1(:,t)),1:K,'UniformOutput',false);
    

    
    C_GT(C_GT>threshold)=1; C_GT(C_GT<=threshold)=0;
    C_GT_cell = arrayfun(@(t) find(C_GT(:,t)),1:K,'UniformOutput',false);
    
    N          = size(C_GT,1); % number of nodes in the network
    NMI.pcd_L1 = gnmi(C_pcd_L1_cell, C_GT_cell, N);

end





