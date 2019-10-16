function F=SeROAP(T)

Td = T;
dims=size(T);
dimension = dims;

for jj=1:length(dims)-1
    Tn = unfold(Td,1);
    [U,S,V] = svds(Tn,1);
    
    if length(dimension) == 2
        w = reshape(U(:,1)*V(:,1)', prod(dimension),1);
        for kk=jj-1:-1:1
            Xn = TT{kk}*w*w';
            w = reshape(Xn,prod(size(Xn)),1);
        end
        F = refold(Xn,dims,1);
    else
        dimension(1) = [];
        TT{jj} = Tn;
        Td = reshape(V(:,1), dimension(1), prod(dimension(2:end)));
        Td =refold(Td,dimension,1);
    end
    
    
end

