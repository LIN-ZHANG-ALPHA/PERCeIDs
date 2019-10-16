function [A,V0]=GGPlantedOverlapPartition(NN,pi,pe,Diag, overlap,overlap_ratio,overlap_community_pair)


% INPUT:
% NN:    vector of  community boundaries
% pi:    internal edge probability
% pe:    external edge probability
% Diag:  if Diag=1, use self-loops; if Diag=0, don't use self-loops
%
% OUTPUT:
% A  adajcency matrix (N-by-N)
% V0 classification vector (N-by-1)
% W  permutation matrix (N-by-N) to put the nodes in order

% 
% if nargin < 5
%     overlap = 0;
%     overlap_ratio = 0.1;
% end


%%
K = length(NN)-1; % number of communities
N = NN(K+1);      % total number of nodes in whole network

A0 = eye(N); % get connection for each community
for k = 1:K
    N1 = NN(k)+1; % boundary ID of current community
    N2 = NN(k+1); % the start ID of next community
    A0(N1:N2,N1:N2) = 1; % set member pairs in the same community all as one
    % N0 = N2-N1;
    % MiMax(k) = N0*(N0-1)/2;
    V0(NN(k)+1:NN(k+1),k)= k; % the community ID for each node
end


%% add overlap bwteen communities

if  overlap
    % overlap_community_pair = [1,2;3,4];% i.e. 1,2, mean only 1,2 has overlap
    overlap_num_nodes      = overlap_ratio * NN(2) ;%  NN(2) is the number of nodes for each community
    for k = 1:size(overlap_community_pair,1) % each overlap pair
        k_s = overlap_community_pair(k,1);
        k_e = overlap_community_pair(k,2);
        % the small index community
        N1_s = NN(k_s + 1) - round(overlap_num_nodes)+ 1; % boundary ID of current community
        N1_e = NN(k_s + 1);
        % A_o(N1_s:N1_e,N1_s:N1_e) = 1; % set member pairs in the same community all as one
        
        % the larger index community
        N2_s = NN(k_e ) + 1; % start
        N2_e = NN(k_e)+ round(overlap_num_nodes) ; % end
        % A_o(N2_s:N2_e,N2_s:N2_e) = 1; % set member pairs in the same community all as one

        N1 = NN(k_s) + 1; % boundary ID of current community
        N2 = NN(k_e + 1); % the start ID of next community
        
        A0(N1:N2_e,N1:N2_e)=1; % set member pairs in the same community all as one
        A0(N1_s:N2,N1_s:N2)=1; % set member pairs in the same community all as one
        
        
        % overlapped community ID
        
        V0(N2_s:N2_e,k_s)= k_s;
        
        V0(N1_s:N1_e,k_e)= k_e;
    end
end






%% assign random connection between members in the same community
A  =  eye(N);
for n1 = 1:N
    for n2 = n1+1:N
        if A0(n1,n2)==1 & rand(1)<pi  % for within community connection
            A(n1,n2)=1; A(n2,n1)=1;
        end
        if A0(n1,n2)==0 & rand(1)<pe % for noise connection
            A(n1,n2)=1; A(n2,n1)=1;
        end
    end
end
%A=A-eye(N);

% % loop all community
% for k=1:K
%     V0(NN(k)+1:NN(k+1),1)= k; % the community ID for each node
%     
% end

if Diag~=0
    for n=1:N; A(n,n)=1; end
else
    for n=1:N; A(n,n)=0; end
end





