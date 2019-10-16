function plot_taxi(states, dat, only_manhattan, show_colorbar)

if only_manhattan
    idx = arrayfun(@(i)strcmp(states(i).BoroCode,'1'), 1:length(states));
    states = states(idx,:);
else
    dat = dat(1:end-1); % remove NaN entry
end

palette = flipud(hot(numel(states)));
for i=1:length(dat)
    states(i).dat = dat(i);
end

cols = makesymbolspec('Polygon', {'dat', [0 max(dat)], 'FaceColor', palette});
mapshow(states, 'DisplayType', 'polygon', 'SymbolSpec', cols, 'EdgeColor', .9*[1 1 1], 'LineWidth', .1);
caxis([0 0.5])
colormap(palette)
axis off;
set(gca,'YTickLabel',[], 'XTickLabel', []);
xlim([970000 1070000]);
ylim([150000 260000]);
if show_colorbar
    colorbar
end