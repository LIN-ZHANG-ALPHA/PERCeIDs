


%%

function [x_all,local_bursty_idx] = gen_local_burst(x,ratio_burst,burst_size,mag,visual)

% inject burst for each signal indpendently
% based on the percentage over all time

if nargin < 4
    mag = 0.1;
end

if nargin < 5
    visual =0;
end


%%

if visual
    figure;
    ax1 = subplot(2,1,1);
    plot(x)
    title(ax1,'Input Signal without burst');
    xlabel('time index');
    ylabel('signal amplitude');
    hold on
end

len_signal = length(x);

x_burst =  zeros(len_signal,1);

len_bursty = floor(ratio_burst*len_signal);
num_burst  = round(len_bursty/burst_size);
% burst_end_position = randsample([max(burst_size_range):len_signal-max(burst_size_range)],num_burst);

num_candidates = floor(len_signal/burst_size);

bursty_idx   = randsample([1:num_candidates],num_burst);


for i = 1: num_burst
    
    % burst_temp_length = randi(burst_size_range,1);
    
    cur_end_position   = min(bursty_idx(i)*burst_size,len_signal); % make sure within x length
    %     if cur_end_position-len_bursty <=0
    %        pause
    %     end
    % x(cur_end_position-burst_size+1:cur_end_position) =   x(cur_end_position-burst_size+1: cur_end_position)+  mag*abs(randn(burst_size,1));
    x_burst(cur_end_position-burst_size+1:cur_end_position) =    mag*abs(randn(burst_size,1));
    
end
% x_burst  = x_burst./norm(x_burst,2);
local_bursty_idx =  find(x_burst>0);

x_all =  x+ x_burst;
% x_all = x_all./norm(x_all,2);

if visual
    subplot(2,1,2)
    plot(x);
    title('Input Signal with burst');
    xlabel('time index');
    ylabel('signal amplitude');
end
end
%%

% function x = gen_local_burst(x,ratio_burst,burst_size,mag,visual)
%
% % inject burst for each signal indpendently
% % based on the percentage over all time
%
% if nargin < 4
%     mag = 0.1;
% end
%
% if nargin < 5
%     visual =0;
% end
%
%
% %%
%
% if visual
%     figure;
%     ax1 = subplot(2,1,1);
%     plot(x)
%     title(ax1,'Input Signal without burst');
%     xlabel('time index');
%     ylabel('signal amplitude');
%     hold on
% end
%
% len_signal = length(x);
%
% len_bursty = floor(ratio_burst*len_signal);
% num_burst  = round(len_bursty/burst_size);
% % burst_end_position = randsample([max(burst_size_range):len_signal-max(burst_size_range)],num_burst);
%
% num_candidates = floor(len_signal/burst_size);
%
% bursty_idx   = randsample([1:num_candidates],num_burst);
%
%
% for i = 1: num_burst
%
%     % burst_temp_length = randi(burst_size_range,1);
%
%     cur_end_position   = min(bursty_idx(i)*burst_size,len_signal); % make sure within x length
% %     if cur_end_position-len_bursty <=0
% %        pause
% %     end
%     x(cur_end_position-burst_size+1:cur_end_position) =   x(cur_end_position-burst_size+1: cur_end_position)+  mag*abs(randn(burst_size,1));
%
% end
%
%
%
% x = x./norm(x,2);
%
% if visual
%     subplot(2,1,2)
%     plot(x);
%     title('Input Signal with burst');
%     xlabel('time index');
%     ylabel('signal amplitude');
% end
% end
