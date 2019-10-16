function [result,idx,M] = eval_sc(A,K,N,C,type)
%% evaluate the performance of spectral clustering algorithms
% Input:
% A: adjacency matrix
% K: number of clusters
% N: number of vertices
% C: groundtruth clusters
% type: which spectral clustering algorithm to use

% Output:
% result: clustering performance
% idx: clustering index
% M: confusion matrix

%% choose between two different algorithms 
if type == 1
    [W,idx,ctrs] = specluster(A,K); % Shi & Malik
elseif type == 2
    [W,idx,ctrs,Vopt] = specluster2(A,K); % Ng
elseif type == 3
    [W,idx,ctrs,Vopt] = specluster3(A,K); % modified version of Ng
end

%% compute benchmarks
pu = purity(N,W,C);
nmi = NMI(N,W,C);
ri = RI(W,C);

result = [pu;nmi;ri];
M = confumat(W,C);