function F=outer(UD)

D=size(UD,2);
for n=1:D,
        dims(n)=size(UD{n},1);
        if dims(n)==1
            UD{n}=UD{n}.';
            dims(n)=size(UD{n},1);
        end;
end;

A = 1;
for n=D:-1:2
    A = kron(A,UD{n});
end
Td = UD{1}*A.';
F = refold(Td,dims,1);



