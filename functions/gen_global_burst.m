


function x = gen_global_burst(signal_length,num_burst,burst_size_range,mag)

% generate global burst
if nargin < 4
    mag = 0.1;
end

% if nargin < 5
%     visual =0;
% end


%%

x =  zeros(signal_length,1);
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


burst_end_position = randsample([max(burst_size_range):signal_length-max(burst_size_range)],num_burst);
for i = 1: num_burst
    burst_temp_length = randi(burst_size_range,1);
    cur_end_position    = burst_end_position(i);
    x(cur_end_position-burst_temp_length+1:cur_end_position) =    mag*abs(randn(burst_temp_length,1));
    % x(cur_end_position-burst_temp_length+1:cur_end_position) =    abs(randn(burst_temp_length,1));
end
% x = mag*x./norm(x,2);
x = x./norm(x,2);
%   if visual
%     subplot(2,1,2)
%     plot(x);
%     title('Input Signal with burst');
%     xlabel('time index');
%     ylabel('signal amplitude');
%   end
end


