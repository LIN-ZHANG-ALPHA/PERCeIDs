




function [x,bursty_idx] = gen_global_burst03(len_signal,ratio_burst, burst_size,mag)

% generate global burst
if nargin < 4
    mag = 0.1;
end

% if nargin < 5
%     visual =0;
% end
rng('default')

%%

x =  zeros(len_signal,1);

num_burst = floor(ratio_burst*len_signal);
%num_burst  = round(len_bursty/burst_size);

bursty_idx   = randsample([1:len_signal],num_burst);

x(bursty_idx) =  mag*abs(randn(num_burst,1));
% num_candidates = floor(len_signal/burst_size);
% 
% bursty_idx   = randsample([1:num_candidates],num_burst);
% 
% for i = 1: num_burst
%     cur_end_position   = min(bursty_idx(i)*burst_size,len_signal); % make sure within x length
%     % x(cur_end_position-burst_size+1:cur_end_position) =  mag*abs(randn(burst_size,1));
%     
%     x(cur_end_position-burst_size+1:cur_end_position) =  mag+(0.1*mag*abs(rand(burst_size,1)));
% end


x = x./norm(x,2);

end


