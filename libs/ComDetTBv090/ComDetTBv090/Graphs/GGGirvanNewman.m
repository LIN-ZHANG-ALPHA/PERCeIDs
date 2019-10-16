function [A,V0]=GGGirvanNewman(N1,K,zi,ze,Diag, overlap,overlap_ratio,overlap_community_pair)
% function [A,V0]=GGGirvanNewman(N1,K,zi,ze,Diag)
% Generation of a Girvan Newman graph
%
% Creates a classical Girvan-Newman graph; returns its adjacency matrix A
% and true community membership vector V0. For details see
% M.E Newman and M. Girvan. "Finding and evaluating community
% structure in networks." Physical review E 69.2 (2004): 026113.
%
% INPUT:
% N1 number of nodes in each community
% K  number of communities
% zi number of internal half-edges per node
% ze number of external half-edges per node
% Diag:  if Diag=1, use self-loops; if Diag=0, don't use self-loops
%
% OUTPUT:
% A  adajcency matrix (N-by-N)
% V0 classification vector (N-by-1)
% W  permutation matrix (N-by-N) to put the nodes in order
%
%EXAMPLE
% [A,V0]=GGGirvanNewman(32,4,16,0,0);
%
rng('default')

if nargin < 6
    overlap = 0;
    overlap_ratio = 0;
    overlap_community_pair = [];
end


pi=zi/(N1-1);
pe=ze/(N1*(K-1));
NN=[0];
for k=1:K
     NN(1,k+1)=k*N1;
end
% [A,V0] = GGPlantedPartition(NN,pi,pe,Diag);

[A,V0] = GGPlantedOverlapPartition(NN,pi,pe,Diag,overlap,overlap_ratio,overlap_community_pair);

