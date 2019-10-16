

function   noise_tensor = generate_noise_tensor(W_tensor,nnz, magnitude)
% generate random tensor
rng('default')

if nargin < 3
    magnitude =0.1;
end

[n1,n2,n3] =  size(W_tensor);

all_elements =  n1*n2*n3;
A                 =  zeros(all_elements,1);
idx_nnz       = randsample(all_elements,nnz);
A(idx_nnz)   = rand(nnz,1);
A =  magnitude*A./norm(A);
noise_tensor = reshape(A, [n1,n2,n3]);