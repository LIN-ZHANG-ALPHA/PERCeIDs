%% Implementation of the SC-GED algorithm
clear all;close all;

%% load data
load synthetic.mat
% load nrc.mat
% load cora.mat

%% setting parameters
N = size(A,1); % number of vertices
M = size(A,3); % number of layers

alpha = 0.5; % example choice of regularization parameter alpha
beta = 100; % example choice of regularization parameter beta
niter = 200;
options = optimset('Display','iter');

%% compute the Laplacian matrices and eigenvalues & eigenvectors
for m = 1:M
    L(:,:,m) = full(sgwt_laplacian(A(:,:,m),'opt','rnormalized')); % random walk Laplacian matrix
    [V(:,:,m),D(:,:,m)] = eigs(L(:,:,m),N,'sr');
end

% main loop
P = V(:,:,1);Q = (V(:,:,1))^(-1);p = P(:)';q = Q(:)';
figure()
for i = 1:niter
    
    % solve P while fixing Q
    [p,fval,exitflag,output] = lbfgs(@comeig_lbfgs,p,options,N,M,L,D,Q,alpha,beta);
    P = reshape(p',N,N);
    
    % solve Q while fixing P
    [q,fval,exitflag,output] = lbfgs(@comeig2_lbfgs,q,options,N,M,L,D,P,alpha,beta);
    Q = reshape(q',N,N);

    % evaluate the objective function
    cost(i) = comeig_lbfgs(p,N,M,L,D,Q,alpha,beta);
    plot(i,cost(i),'.r')
    hold on, drawnow
    
    % stopping criterion
    if i > 1 && abs(cost(i)-cost(i-1)) < 10^(-5)
        break
    end
    
end

Vk = P(:,1:K);
% performance evaluation
result = eval_kmeans(Vk,K,N,C)
