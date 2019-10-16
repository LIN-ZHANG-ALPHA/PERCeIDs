 function [Xr, Er]=dcpd(T,R, itr_max, tol, funcMethod)
  
I =size(T); % tensor dimensions
D=length(I); %tensor order

itr = 0;
error = Inf;
Yr{1} = T;
Er0 = T;

for rr=1:R
    Xr{rr} = funcMethod(Yr{rr});
    if rr < R
        Yr{rr+1} = Yr{rr} - Xr{rr};
    else
        Er =   Yr{R} - Xr{R};
    end
end
 
while error > tol && itr <= itr_max
    itr = itr + 1;  % l > 1;
    for rr=1:R
        Yr{rr} = Xr{rr}+ Er;
        Xr{rr} = funcMethod(Yr{rr});
        Er = Yr{rr}- Xr{rr};
    end
    error = abs(norm(Er(:))-norm(Er0(:)));
    Er0 = Er;
  
end

end