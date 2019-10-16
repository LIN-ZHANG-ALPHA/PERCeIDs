

function x = inject_global_occlusion(x,global_occlusion, visual_global_occlusion)
if nargin < 3
    visual_global_occlusion =0;
end

if visual_global_occlusion
    figure;
    ax1 = subplot(2,1,1);
    plot(x)
    title(ax1,'Input Signal without global occlusion');
    xlabel('time index');
    ylabel('signal amplitude');
    hold on
end

x = x.*global_occlusion;
x = x./norm(x,2);
if visual_global_occlusion
    subplot(2,1,2)
    plot(x);
    title('Input Signal with global occlusion');
    xlabel('time index');
    ylabel('signal amplitude');
end
end