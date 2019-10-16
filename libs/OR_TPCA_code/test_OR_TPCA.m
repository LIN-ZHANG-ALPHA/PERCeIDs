%% This code is used in the paper "Outlier-Robust Tensor PCA" (CVPR'17)
%% for semi-supervised learning.
%% If you have any problem, you could contact the implementor Pan Zhou (panzhou3@gmail.com).


addpath(genpath('basis_funcs'));

%% step 1. read data 
% data_dir='D:/data/Yale/38';
% [ X,labels ] = make_label3(data_dir);
load('YaleB.mat');

%% step 2. use our method to denoise data
X=X/255.0;
max_iter=200;%% maximal iteration
tol = 1e-8;%% terminal condition
tic;
[L,E,rankL]=OR_TPCA(X,max_iter,tol);
t=toc;



%% step 3. classify the data
%% step 3.1 randomly select training and testing data
[ XX ] = tensor2matrix( L);
num=9;
[ Z1,Z2,tr_label,ts_label] = choose_data(XX,labels,num);

%% step 3.2 compute the classification acc, linear classifier 
gamma=1;
[acc_linear] = predict_small( Z1,Z2,tr_label,ts_label,gamma);
fprintf('\n OR-TPCA Linear Classifier: Acc=%.3f\n',acc_linear);
