function Periods =  get_period(basis_periods,Y, thr)
if nargin < 3
    thr = 0.1;
end

[m,n]   = size(Y); % n: number of instances(here is signals)
Ind     = Y.*(Y>thr);
Init_P  = repmat(basis_periods,[1,n]).*Ind;

% B = prod(A); % product of the elements in each column
Periods =  zeros(n,1);
for i   =  1:n
    temp           = Init_P(:,i);
    idx_nonzers    = find(temp~=0);
    val_nonzers    = temp(idx_nonzers);
    Periods(i)     = lcms(val_nonzers);
end

end
