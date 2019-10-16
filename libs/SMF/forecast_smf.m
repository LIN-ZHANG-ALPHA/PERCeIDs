function [Tpred, U, W] = forecast_smf(T, TL, forecast_steps, k, s, alpha, init_cycles)

[U, W, ~] = smf(T, TL, k, s, alpha, init_cycles, false);
for t=1:forecast_steps
    t_seas = size(T, 3) - s + mod(t-1, s) + 1; % corresponding value on last fitted period
    Tpred(:,:,t) = U{1} * sparse(diag(W(t_seas,:))) * U{2}';
end