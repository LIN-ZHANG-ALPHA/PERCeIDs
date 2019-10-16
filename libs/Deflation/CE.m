function F=CE(T,X)

% X: rank1-approximation obtained with any other method
% T: Tensor whose rank-1 approximation is computed.

dimension = size (T);

%Initialization
T1 = unfold(T,1);
[Ui,Si,Vi] = svds(X(:,:,1),1);

x0 = Ui;
y0 =  Vi;

%Compute M
M = zeros(prod(dimension(1:2)),prod(dimension(1:2)));
for tt=1:dimension(3)
    vectT = reshape(T(:,:,tt),dimension(1)*dimension(2),1);
    M = M + vectT*vectT';
end

%Compute Kronecker Decomposition
[Q, P] = krondecomp(M,fliplr(dimension(1:2)));

numR = length(Q);
Az = zeros(dimension(2),dimension(2));
Bz =  zeros(dimension(1),dimension(1));
%Compute matrices A and B
for jj=1:dimension(1)
    for ii=1:dimension(1)
        Ae{ii,jj} = Az;
        for rr=1:numR
            Ae{ii,jj} = Ae{ii,jj}+ P{rr}(ii,jj)*conj(Q{rr});
        end
    end
end
for jj=1:dimension(2)
    for ii=1:dimension(2)
        Be{ii,jj} = Bz;
        for rr=1:numR
            Be{ii,jj} = Be{ii,jj}+ conj(Q{rr}(ii,jj))*P{rr};
        end
    end
end

lambda0 = -inf;
error = inf;
tol = 1e-6;
u = x0;
v = y0;
itrcs = 0;

while error >= tol
    itrcs = itrcs + 1;
    for jj=1:dimension(2)
        for ii=1:dimension(2)
            My(ii,jj) = u'*Be{ii,jj}*u;
        end
    end
    
    [Wy,Dy] = eig(My);
    idx = find(real(diag(Dy)) == max(real(diag(Dy))));
    v = Wy(:,idx);
    
    for jj=1:dimension(1)
        for ii=1:dimension(1)
            Mx(ii,jj) = v'*Ae{ii,jj}*v;
        end
    end
    [Wx,Dx] = eig(Mx);
    idy = find(real(diag(Dx)) == max(real(diag(Dx))));
    u = Wx(:,idy);
    
    lambda = real(Dx(idy,idy));
    error = abs(lambda-lambda0);
    lambda0 = lambda;
    
end
w = kron(conj(v),u);
F = [];
for kk=1:dimension(3)
    ak = w'*reshape(T(:,:,kk),dimension(1)*dimension(2),1);
    F = [F reshape(ak*w,dimension(1),dimension(2))];
end

F = refold(F,dimension,1);


end
