%% randomly select training and testing samples
function [ Z1,Z2,tr_labels,ts_lables] = choose_data(X,label,tr_num)
%% X: samples, label: the labels of samples in X
%% tr_num: training number for each class

%% Z1: selected training samples, Z2: selected testing samples,
%% tr_labels: labels of Z1, ts_lables: labels of Z2

nclass=length(unique(label));

tr_idx = [];
ts_idx = [];
for jj = 1:nclass,
    idx=find(label==jj);
    num=length(idx);
    idx_rand = randperm(num);
    tr_idx= [tr_idx; idx(idx_rand(1:tr_num))];
    ts_idx= [ts_idx; idx(idx_rand(tr_num+1:num))];
end
tr_labels=label(tr_idx);
ts_lables=label(ts_idx);
Z1=X(:,tr_idx);
Z2=X(:,ts_idx);
end

