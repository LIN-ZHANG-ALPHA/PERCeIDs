function Ws=refold(Wn,dimW,n)
if size(Wn,1)==1,Wn=Wn.';end;
D=length(dimW);ind=1:D;ind_n=ind;ind_n(n)=[];
dimW_n=dimW(ind_n);
Wp=reshape(Wn,[dimW(n),dimW_n]);
Ws=permute(Wp,[2:n 1 n+1:D]);

