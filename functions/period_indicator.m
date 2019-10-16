
function  indicator = period_indicator(c,n)
% n : could be a vector

if intersect(c,n)
    indicator = 0;
else
    indicator = 1;
end

