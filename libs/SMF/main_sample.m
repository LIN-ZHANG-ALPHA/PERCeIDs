% Sample code that runs smf on a small sample of the taxi dataset, and
% plots the results.

addpath util
addpath util/distinguishable_colors
addpath tensor_toolbox

% data format: (row index, column index, time, count)
dat = csvread('data/taxi_sample.csv');
T = sptensor(dat(:,1:3), dat(:,4));
TL = tensor2list(T);
% additional shape data needed to plot geographical areas
load('data/taxi_shapes.mat');

%%
s = 24 * 7; % period
k = 3; % number of components
alpha = .1;
output_anom = false;
init_cycles = 3;
cols = distinguishable_colors(k);

%%

[U, W, E] = smf(T, TL, k, s, alpha, init_cycles, output_anom);

% or for forecasting:
% forecast_steps = 3;
% [forecast, U, W] = forecast_smf(T, TL, forecast_steps, k, s, alpha, init_cycles);

%% Plot weekly pattern of each component
figure;
for c=1:k
    subplot(3,1,c);
    plot([W(end-23:end,c); W(end-s:end-24,c)], 'Color', cols(c,:), 'LineWidth', 1.5); hold on;
    set(gca, 'XTick', 13:24:s);
    set(gca, 'XTickLabel', {'M','T','W','T','F','S','S'});
    set(findall(gcf,'Type','Axes'),'FontSize',24);
    set(findall(gcf,'Type','Text'),'FontSize',24);
    set(findall(gcf,'Type','Legend'),'FontSize',24);
end

%% Plot taxi maps (from and to) 
lblue = [235 244 255] / 255;
for c=1:k
    figure('Color', lblue, 'Position', [0 0 500 500]);
    plot_taxi(map_shapes, U{1}(:,c), true, false); 
    fig = gcf; set(fig, 'InvertHardcopy', 'off');
    figure('Color', lblue, 'Position', [0 0 500 500]);
    plot_taxi(map_shapes, U{2}(:,c), true, false);
    fig = gcf; set(fig, 'InvertHardcopy', 'off');
    hold off;
end