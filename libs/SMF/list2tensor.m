function T = list2tensor(TL)

subs1 = [];
subs2 = [];
subs3 = [];
vals = [];

for t = 1:length(TL)
    [i,j,s] = find(TL{t});
    subs1 = [subs1; i];
    subs2 = [subs2; j];
    subs3 = [subs3; t*ones(size(i))];
    vals = [vals; s];
end

T = sptensor([subs1 subs2 subs3], vals, [size(TL{1}) length(TL)]);
end