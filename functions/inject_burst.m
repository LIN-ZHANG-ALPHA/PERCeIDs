%% 

function x = inject_burst(x,num_burst,burst_size_range,mag,visual)

% inject burst for each signal indpendently
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

x_len = length(x);

burst_end_position = randsample([max(burst_size_range):x_len-max(burst_size_range)],num_burst);

for i = 1: num_burst
    
    burst_temp_length = randi(burst_size_range,1);
    
    cur_end_position   = burst_end_position(i);
    
    x(cur_end_position-burst_temp_length+1:cur_end_position) =   x(cur_end_position-burst_temp_length+1: cur_end_position)+  mag*abs(randn(burst_temp_length,1));
    
    
    
end

x = x./norm(x,2);

  if visual
    subplot(2,1,2)
    plot(x);
    title('Input Signal with burst');
    xlabel('time index');
    ylabel('signal amplitude');
  end
end
  