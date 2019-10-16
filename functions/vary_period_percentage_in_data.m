

function x_profile = vary_period_percentage_in_data(x_profile, opts_syndata)



period_length                           =  floor(opts_syndata.Input_Datalength*opts_syndata.period_percentage);
num_non_period =  opts_syndata.Input_Datalength-period_length;
idx_non_period   = randsample( opts_syndata.Input_Datalength, num_non_period);

 tmp =  abs(randn(num_non_period,1));
 x_profile(idx_non_period) = opts_syndata.non_period_mag*tmp./norm(tmp);

% tmp =  abs(randn(opts_syndata.Input_Datalength-period_length,1));
% x_profile(period_length+1:end) = tmp./norm(tmp);
% 
x_profile                                    =  x_profile./norm(x_profile);