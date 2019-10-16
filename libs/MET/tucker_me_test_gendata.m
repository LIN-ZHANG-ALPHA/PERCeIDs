function [X,G,U] = tucker_me_test_gendata(csz,tsz,pnz)
%TUCKER_ME_TEST_GENDATA Generate sparse array for tucker_me tests.
%
%   X = GENDATA(CSZ,TSZ,PNZ) generates a tensor as follows. 1) Randomly
%   generates a core tensor, G, of size CSZ. 2) Expand it into a tensor of
%   size  TSZ by multiplying it by appropriately sized random matrices in
%   each mode. 3) Save only the largest nonzeros, as specified by PNZ, the
%   percentage of nonzeros to be saved.
%
%   [X,G,U] = GENDATE(...) also returns the core tensor and matrices that
%   were use to generate X.
%
%   Example
%   X = gendata([2 2 2], [10 10 10], .10) - generates a tensor of size 10 x
%   10 x 10 that came from a core of size 2 x 2 x 2 but where the smallest
%   entries were deleted.
%
%   See also TUCKER_ME_TEST.
%
%   Code by Tamara Kolda and Jimeng Sun, 2008. 
%
%   Based on the paper:
%   T. G. Kolda and J. Sun. Scalable Tensor Decompositions for Multi-aspect
%   Data Mining. In: ICDM 2008: Proceedings of the 8th IEEE International
%   Conference on Data Mining, December 2008.  


% Number of tensor dimensions
N = length(csz);

% Generate random core tensor
G = tenrand(csz);

% Generate random U-matrices
for n = 1:N
    U{n} = rand( [tsz(n), csz(n)] );
end

% Create full tensor
Xfull = ttm(G,U);

% Sparsify
[v,idx] = sort(Xfull(:),'descend');
stop = round( pnz * length(idx) );
v(stop:end) = 0;
X = sptensor( reshape(v,size(Xfull)) );

 


