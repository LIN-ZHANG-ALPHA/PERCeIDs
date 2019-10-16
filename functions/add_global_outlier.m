

function  W_tensor = add_global_outlier(W_tensor,param)

rng('default')

[w,h,n]    = size(W_tensor);
new_W    =  zeros(size(W_tensor));

num_burst   = floor(param.global_ratio_outlier*n);
idx_bursty = randsample(n,num_burst);

for ii=1:length( idx_bursty)
    idx = idx_bursty(ii);
    new_W(:,:,idx) =  param.mag_gl_burst*rand(w,h); % add random to all community at a selected time point
     %W_tensor(:,:,idx) =  param.mag_gl_burst*rand(w,h); % add random to all community at a selected time point
end

W_tensor = W_tensor + new_W;


