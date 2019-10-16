function [result,idx,M] = eval_kmeans(V,K,N,C)
%% evaluate clustering performance after applying k-means to spectral embedding
% Input:
% V: representation based on which we apply k-means
% K: number of clusters
% N: number of vertices
% C: groundtruth clusters

% Output:
% result: clustering performance
% idx: clustering index
% M: confusion matrix

%% use built-in multiple tries
[idx,ctrs] = kmeans(V,K,'emptyaction','singleton','replicates',20);
for k = 1:K
    W{k} = find(idx==k);
end

%% compute benchmarks
pu = purity(N,W,C);
nmi = NMI(N,W,C);
ri = RI(W,C);

result = [pu;nmi;ri];
M = confumat(W,C);