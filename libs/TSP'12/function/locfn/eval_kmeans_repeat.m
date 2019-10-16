function performance = eval_kmeans_repeat(V,K,N,C,niter)
%% evaluate clustering performance after applying k-means to spectral embedding
%% average results from niter repeats, and compute mean and standard deviation
% Input:
% V: representation based on which we apply k-means
% K: number of clusters
% N: number of vertices
% C: groundtruth clusters
% niter: number of repeated runs

% Output:
% performance: average clustering performance of niter runs

for i = 1:niter
    [idx,ctrs] = kmeans(V,K,'emptyaction','singleton');
    for k = 1:K
        W{k} = find(idx==k);
    end
    
    pu = purity(N,W,C);
    nmi = NMI(N,W,C);
    ri = RI(W,C);
    result(:,i) = [pu;nmi;ri];
end

performance(1) = mean(result(1,:));
performance(2) = std(result(1,:));
performance(3) = mean(result(2,:));
performance(4) = std(result(2,:));
performance(5) = mean(result(3,:));
performance(6) = std(result(3,:));