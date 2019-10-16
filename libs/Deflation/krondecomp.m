function [Q,P] = krondecomp(M,dimension);
    Maux = [];
    for jj=1:dimension(1)
        for ii=1:dimension(1)
            vMaux = reshape(M((ii-1)*dimension(2)+1:ii*dimension(2),(jj-1)*dimension(2)+1:jj*dimension(2)),dimension(2)*dimension(2),1);
            Maux = [Maux; vMaux'];
        end
    end
    [U,S,V] = svd(Maux);
    Sq = sqrt(S);
    for kk=1:rank(Maux)
        Q{kk} = conj( Sq(kk,kk)*reshape(U(:,kk),dimension(1),dimension(1)) );
        P{kk} = Sq(kk,kk)*reshape(V(:,kk),dimension(2),dimension(2));
    end