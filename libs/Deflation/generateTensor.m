function  X = generateTensor(dims,R, flagComplex)

tensor_order = length(dims);

X = zeros(dims(1),prod(dims(2:end)));

for r = 1:R
    X1{r} = zeros(dims(1),prod(dims(2:end)));
    A{r} = zeros(dims(1),prod(dims(2:end)));
    vL{r} = 1;
    for jj=1:tensor_order
        aa = (1-2*rand(dims(jj),1))+j*flagComplex*(1-2*rand(dims(jj),1));
        vL{r} = vL{r}*norm(aa);
        vA{r,jj} = aa/norm(aa);
     end
end


for r=1:R
    K = 1;
    for jj=tensor_order:-1:2
        K = kron(K,vA{r,jj});
    end
    X = X + vL{r}*vA{r,1}*K.';
end

X = refold(X,dims,1);