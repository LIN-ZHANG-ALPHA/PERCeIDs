%% Compute spectral kernel (step-function kernel)
function K = sfkernel(A,d)
N = size(A,1);
[S,C] = graphconncomp(sparse(A));

if S == 1
    L = full(sgwt_laplacian(A,'opt','normalized'));
    [V,D] = eigs(L,d,'sa');
elseif S > 1 && N < 500
    L = normadj(A);
    [V,D] = eigs(L,N,'la');
    V = V(:,1:d);
elseif S > 1 && N >= 500
    L = normadj(A);
    [V,D] = eigs(L,d,'la');
    V = V(:,1:d);
end

% N = size(A,1);
% L = full(sgwt_laplacian(A,'opt','normalized'));
% [V,D] = eigs(L,N,'sa');
% V = V(:,1:d);

K = zeros(size(A));
for i = 1:d
    K = K + V(:,i)*V(:,i)';
end