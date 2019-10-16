function [accuray] = predict_small( Z1,Z2,tr_lable,ts_label,lambda)

len1=length(tr_lable);
numclass=length(unique(tr_lable));
% W=inv(lambda*eye(size(Z1,2))+Z1'*Z1);
% W=Z1*W*Z1'./(lambda);

W=Z1'*Z1;
for i=1:size(W,1)
   W(i,i)=lambda+W(i,i);
end
W=inv(W);
W=W./(lambda);

W=Z1*W;
W=W*Z1';
W=-W;
for i=1:size(W,1)
   W(i,i)=1/lambda+W(i,i);
end

H=zeros(numclass,len1);
for il=1:len1
    H(tr_lable(il),il)=1;
end
WW=H*Z1';
W=WW*W;
clear Z1;
clear H;


WW=W*Z2;

clear W;
clear Z2;

[CC,C]=max(WW);

acc = zeros(numclass, 1);
for jj = 1 : numclass,
        c = jj;
        idx = find(ts_label == c);
        curr_pred_label = C(idx);
        curr_gnd_label = ts_label(idx)';
        acc(jj) = length(find(curr_pred_label == curr_gnd_label));%/length(idx);
end; 
accuray= sum(acc)/length(ts_label);
end

