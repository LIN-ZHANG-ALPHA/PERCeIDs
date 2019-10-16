function T=contract(UD,G)

dimG=size(G);D=length(dimG);
if max(size(G))==1, D=size(UD,2);error('G is a scalar: use G*outer(UD) instead');
elseif size(UD,2)~=D, error('UD and G of incompatible orders');
end;

for n=1:D,
        dims(n)=size(UD{n},1);
        if size(UD{n},2)~=dimG(n), error('UD and G of incompatible %th dimension\n',n);end;
end;
dimT=dimG;T=G;
for n=1:D,
        dimT(n)=dims(n);
        T=refold(UD{n}*unfold(T,n),dimT,n);
end;
