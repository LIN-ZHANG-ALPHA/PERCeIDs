function TL = tensor2list(T)

Tsz = double(size(T));
ntimes = Tsz(3);
TS = T.subs;
TV = T.vals;

for t=1:ntimes
    TL{t} = sparse(Tsz(1), Tsz(2));
end

for i=1:length(TV)
    row = TS(i,1);
    col = TS(i,2);
    t = TS(i,3);
    TL{t}(row, col) = TL{t}(row, col) + TV(i);
end

end