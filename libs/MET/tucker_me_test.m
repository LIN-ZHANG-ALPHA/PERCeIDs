%TUCKER_ME_TEST Very simple tests of tucker_me.
%   Code by Tamara Kolda and Jimeng Sun, 2008. 
%
%   Based on the paper:
%   T. G. Kolda and J. Sun. Scalable Tensor Decompositions for Multi-aspect
%   Data Mining. In: ICDM 2008: Proceedings of the 8th IEEE International
%   Conference on Data Mining, December 2008.  

%% Set up
csz = [3 6 9 12];
tsz = [50 50 50 50];
X = gendata(csz, tsz, .001);

%%
fprintf('-----------------------------------------------------------\n');
fprintf('%-20s | %-7s | %-10s |%-10s \n','Method','Time(s)','Error', 'Memory ratio');
fprintf('-----------------------------------------------------------\n');
%%
tic
[T,Uinit] = tucker_als(X,csz);
t = toc;
fprintf('%-20s | %7.2f | %10.3e \n', 'tucker_als (standard)', t, 1-norm(T)/norm(X));
 
% Make sure that they all use the same initial guess
opts.init = Uinit;

tic
[T, mem_orig] = tucker_me(X,csz, 0, opts);
t = toc;
fprintf('%-20s | %7.2f | %10.3e |%f \n', 'tucker_me (standard)', t, 1-norm(T)/norm(X), 1);
 

%%
tic
[T,mem] = tucker_me(X,csz,1,opts);
t = toc;
fprintf('%-20s | %7.2f | %10.3e|%f  \n', 'tucker_me (slicewise)', t, 1-norm(T)/norm(X), mem/mem_orig);

%%
tic
[T,mem] = tucker_me(X,csz,2,opts);
t = toc;
fprintf('%-20s | %7.2f | %10.3e |%f \n', 'tucker_me (fiberwise)', t, 1-norm(T)/norm(X), mem/mem_orig);

%% Really slow! 
tic
[T,mem] =  tucker_me(X,csz,3,opts);
t = toc;
fprintf('%-20s | %7.2f | %10.3e |%f \n', 'tucker_me (elementwise)', t, 1-norm(T)/norm(X), mem/mem_orig);
