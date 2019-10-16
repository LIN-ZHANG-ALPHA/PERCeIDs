
% function x = gen_global_occlusion(signal_length,occulusion_ratio)
function x = gen_global_occlusion(signal_length,num_occlusion,occlusion_size_range)
% get an binary indicator of occlusion in the signal
% 04-17-19
% @linzhang@ualbany

x =  ones(signal_length,1); % 


occlusion_end_position = randsample([max(occlusion_size_range):signal_length-max(occlusion_size_range)],num_occlusion);
for i = 1: num_occlusion
    occlusion_temp_length = randi(occlusion_size_range,1);
    cur_end_position          = occlusion_end_position(i);
    x(cur_end_position-occlusion_temp_length+1:cur_end_position) =    zeros(occlusion_temp_length,1);
    % x(cur_end_position-burst_temp_length+1:cur_end_position) =    abs(randn(burst_temp_length,1));
end



% occlusion_size = floor(occulusion_ratio*signal_length);
% occlusion_bits =  randsample(signal_length,occlusion_size);
% x(occlusion_bits) = 0;