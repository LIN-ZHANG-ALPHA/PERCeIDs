function [W,idx,ctrs] = specluster(A,K)
% implement the spectral clustering algorithm by Shi & Malik
% using eigenvectors of Laplacian L_rw = D^(-1)*L
%
% in case of connected graph, in order to improve numerical stability, 
% first calculate the eigenvectors of the symmetric normalized Laplacian 
% L_sym = D^(-1/2)*L*D^(-1/2)
% then transform the results into that of L_rw
% f = D^(-1/2)*g

%% check the number of components of the graph
N = size(A,1);
[S,C] = graphconncomp(sparse(A));

%% two different cases: connected and disconnected graphs
if S == 1

    L = full(sgwt_laplacian(A,'opt','normalized'));
    [V,D] = eigs(L,K,'sa');
    V = V(:,1:K);

    degrees=full(sum(A));
    degrees=degrees(:);
    for i = 1:K
        V(:,i) = V(:,i)./sqrt(degrees); % transformation
        V(:,i) = V(:,i)/norm(V(:,i));   % re-normalization
    end

    [idx,ctrs] = kmeans(V,K,'emptyaction','singleton','replicates',500); % k-means
%     [idx,ctrs] = sortedkmeans(V,K) % used when cluster ordering is needed
    
elseif S > 1 && N < 500
    
    L = full(sgwt_laplacian(A,'opt','rnormalized'));
    [V,D] = eigs(L,N,'sr');
    [idx,ctrs] = kmeans(V(:,1:K),K,'emptyaction','singleton','replicates',500);
    
elseif S > 1 && N >= 500
    
    L = full(sgwt_laplacian(A,'opt','rnormalized'));
    [V,D] = eigs(L,K,'sr');
    [idx,ctrs] = kmeans(V(:,1:K),K,'emptyaction','singleton','replicates',500);
    
end

%% compute cluster assignment W
for i = 1:K
    W{i} = find(idx==i);
end