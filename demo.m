

clc; clear all;
addpath(genpath(pwd))
rng('default')
%%  load data
data_path  = 'data/MIT/';
data_name  = 'mit_hour_all';
load([data_path,'/',data_name,'.mat']) % 

data_GT_name = 'communities_lab'; % _o: overlap commu; _no: non-overlap commu
load([data_path,'/',data_GT_name,'.mat']) % 

data_save = ['demo_',data_name];
opts.GT   = communities_lab;
opts.K    = size(opts.GT,2); %  num of communities

%%  parameter setting
opts.lambda_0           = 1;
opts.lambda_1           = 1;
opts.lambda_2           = 1;

opts_pcd.max_iter       = 200;
opts_pcd.Pmax           = 10;
opts_pcd.Penalty_type   = 'square';
%%  main function 

[Fac.Fac_PCD_L1] = detect_community_PCD(X,opts,opts_pcd);



%% evlauation
opts.JSDiv = 1;
opts.NMI   = 1;

opts.comm_threshold     = 0.21;
[eval.DIV_order,eval.DIV_best, eval.gNMI]  = evaluation_PCD(Fac.Fac_PCD_L1,opts);







