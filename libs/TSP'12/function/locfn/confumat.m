function M = confumat(W,C)
% the final confusion matrix can be obtained by permuting the columns of M
% such that the sum of the diagonal entries of M is maximized

l = length(W);

for i = 1:l
    for j = 1:l
        M(i,j) = groupcmp(W{j},C{i});
    end
end