function F=T_HOSVD(T)

dims=size(T);D=length(dims);ind=1:D;

for n=1:D,
    ind_n=ind;ind_n(n)=[];
    dims_n=dims(ind_n);
    TT=permute(T,[ind(n),ind_n]);
    Tn=reshape(TT,[dims(n),prod(dims_n)]);
    [U,S,V]=svd(Tn,'econ');
    UD{n}=U(:,1);UDT{n}=U(:,1)';
end;
ss=contract(UDT,T); 

    
F = ss*outer(UD);