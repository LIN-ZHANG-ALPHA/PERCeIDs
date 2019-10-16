function plot_matrix(A)
if nargin < 2
    name = '';
end
scale = max(size(A));
sz1 = size(A,1) / scale * 12;
sz2 = size(A,2) / scale * 12;
imagesc(A);
set(gca, 'CLim', [0, max(max(A))]);
if all((A == 1) + (A == 0))
    colormap(flipud(gray));
else
    redColorMap = [ones(1, 128), linspace(1, 0, 128)];
    greenColorMap = [linspace(0, 1, 128), linspace(1, 0, 128)];
    blueColorMap = [linspace(0, 1, 128), ones(1, 128)];
    colorMap = [redColorMap; greenColorMap; blueColorMap]';
    colormap(colorMap);
    h = colorbar;
    set(h, 'ylim', [0 max(max(A))]);
end
% set(gcf,'PaperUnits','inches','PaperPosition',[1 1 2+sz2 2+sz1])
title(sprintf('Size %d', size(A,1)), 'FontSize', 11);
set(gca,'XTickLabel',[]); set(gca,'YTickLabel',[]);
end