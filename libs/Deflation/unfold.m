function Wn=unfold(W,n)
dims=size(W);D=length(dims);ind=1:D;ind_n=ind;ind_n(n)=[];
dims_n=dims(ind_n);
WW=permute(W,[ind(n),ind_n]);
Wn=reshape(WW,[dims(n),prod(dims_n)]);


