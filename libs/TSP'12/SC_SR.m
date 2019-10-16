%% Implementation of the SC-SR algorithm
clear all;close all;

%% load data
load synthetic.mat
% load nrc.mat
% load cora.mat

%% setting parameters
N = size(A,1); % number of vertices
M = size(A,3); % number of layers

if N > 500
    dim = K;
else
    dim = N;
end

%% compute the Laplacian matrices and eigenvalues & eigenvectors
L = zeros(N,N,M);
V = zeros(N,dim,M);
D = zeros(dim,dim,M);

for m = 1:M
    % L_\text{NORM}: symmetric normalized Laplacian matrix
    L(:,:,m) = normadj(A(:,:,m));
    [V(:,:,m),D(:,:,m)] = eigs(L(:,:,m),dim,'la');
    % largest eigenvectors of the normalized adjacency matrix are equal to 
    % smallest eigenvectors of the normalized Laplacian matrix
    
    % L_\text{RW}: random walk Laplacian matrix
    degrees = vec(full(sum(A(:,:,m))));
    for i = 1:K
        V(:,i,m) = V(:,i,m)./sqrt(degrees); % transform H = D^(-1/2)*T
        V(:,i,m) = V(:,i,m)/norm(V(:,i,m)); % re-normalize columns
    end
end

V1 = V(:,:,1); D1 = D(:,:,1);
V2 = V(:,:,2); D2 = D(:,:,2);
V3 = V(:,:,3); D3 = D(:,:,3);

%% spectral regularization
As = A(:,:,2); % graph topology for first regularization
As2 = A(:,:,3); % graph topology for second regularization
F = V1(:,1:K)'; % function to regularize
V_regul = F';
% the choice of the layers acting as functions to be regularized, or graph
% topology in the regularization process, depends on the informativeness of
% the individual graph layers
% for example, in case of three layers, we propose to order the layers in
% decreasing informativeness: A(:,:,1) > A(:,:,2) > A(:,:,3), and then
% A(:,:,1): functions to be regularized
% A(:,:,2): graph topology for first regularization
% A(:,:,3): graph topology for second regularization
% =Notice=:
% the graph layer selected to generate functions to be regularized shoud be
% connected (so that the computation between 24-37 does not lead to NaN)

step = 0.01; % step size
lambda1 = [1.5:0.1:3.5]; % regularization parameter for first regularization (example values)
lambda2 = [0.1:0.1:1]; % regularization parameter for second regularization (example values)
result1 = zeros(3,length(lambda1));
result2 = zeros(length(lambda1),length(lambda2),3);

nmi_max = 0;
result_max = zeros(3,1);
idx_max = zeros(N,1);
V_max = zeros(N,K);
nmi2_max = 0;
result2_max = zeros(3,1);
idx2_max = zeros(N,1);
V2_max = zeros(N,K);

%% oneshot results
for i = 1:length(lambda1) % combine the first two layers
    for k = 2:K
        V_regul(:,k) = regul_graph(As,F(k,:),step,lambda1(i))'; % regularization on graphs
    end
    [result1(:,i),idx1,~] = eval_kmeans(V_regul,K,N,C); % clustering based on first regularization
    
    if nmi_max < result1(2,i)
        nmi_max = result1(2,i);
        result_max = result1(:,i);
        idx_max = idx1;
        V_max = V_regul;
    end
    F2 = V_regul';
    V_regul2 = F2';

    for j = 1:length(lambda2) % combine the previous result and the third layer
        for k = 2:K
            V_regul2(:,k) = regul_graph(As2,F2(k,:),step,lambda2(j))'; % regularization on graphs
        end
        [result2(i,j,:),idx2,~] = eval_kmeans(V_regul2,K,N,C); % clustering based on second regularization
        
        if nmi2_max < result2(i,j,2)
            nmi2_max = result2(i,j,2);
            result2_max = result2(i,j,:);
            idx2_max = idx2;
            V2_max = V_regul2;
        end
    end
end

%% average of 20 test runs
V_regul = F';
result1 = zeros(6,length(lambda1));
result2 = zeros(length(lambda1),length(lambda2),6);

for i = 1:length(lambda1)
    for k = 2:K
        V_regul(:,k) = regul_graph(As,F(k,:),step,lambda1(i))';
    end
    result1(:,i) = eval_kmeans_repeat(V_regul,K,N,C,20);
    F2 = V_regul';
    V_regul2 = F2';

    for j = 1:length(lambda2)
        for k = 2:K
            V_regul2(:,k) = regul_graph(As2,F2(k,:),step,lambda2(j))';
        end
        result2(i,j,:) = eval_kmeans_repeat(V_regul2,K,N,C,20);
    end
end
