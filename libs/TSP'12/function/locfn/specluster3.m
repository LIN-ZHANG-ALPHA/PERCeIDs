function [W,idx,ctrs,Vopt] = specluster3(A,K)
% implement the spectral clustering algorithm by Ng
% using eigenvectors of the symmetric normalized Laplacian L_sym = D^(-1/2)*L*D^(-1/2)
% then apply row normalization

% this is a modified version of specluster2.m, for the case when
% the input A is defined as summation of normalized adjacency matrices (or spectral kernels)
% we apply spectral decomposition directly

%% check the number of components of the graph
N = size(A,1);
[S,C] = graphconncomp(sparse(A));

%% two different cases: connected and disconnected graphs
if S == 1
    
    L = A; % A is defined as summation of normalized adjacency matrices (or spectral kernels)
    [V,D] = eigs(L,K,'la');
    Vopt = V(:,1:K);
    V = rnorm(V(:,1:K));

    [idx,ctrs] = kmeans(V,K,'emptyaction','singleton','replicates',500); % k-means
%     [idx,ctrs] = sortedkmeans(V,K) % used when cluster ordering is needed

elseif S > 1 && N < 500

%     L = full(sgwt_laplacian(A,'opt','normalized'));
%     [V,D] = eigs(L,N,'sa');
    L = A;
    [V,D] = eigs(L,N,'la');
    Vopt = V(:,1:K);
    V = rnorm(V(:,1:K));

    [idx,ctrs] = kmeans(V,K,'emptyaction','singleton','replicates',500); % k-means
    
elseif S > 1 && N >= 500
    
%     L = full(sgwt_laplacian(A,'opt','normalized'));
%     [V,D] = eigs(L,K,'sa');
    L = A;
    [V,D] = eigs(L,K,'la');
    Vopt = V(:,1:K);
    V = rnorm(V(:,1:K));

    [idx,ctrs] = kmeans(V,K,'emptyaction','singleton','replicates',500); % k-means
    
end
    
%% compute cluster assignment W 
for i = 1:K
    W{i} = find(idx==i);
end