function [ XX ] = tensor2matrix( X)

[n1,n2,n3]=size(X);
XX=zeros(n1*n2,n3);
for i=1:n3
    im=X(:,:,i);
    im=reshape(im,[n1,n2]);
    XX(:,i)=im(:);
end

end

