
function x = inject_global_burst(x,global_burst, visual)
if nargin < 3
    visual =0;
end

if visual
    figure;
    ax1 = subplot(2,1,1);
    plot(x)
    title(ax1,'Input Signal without global burst');
    xlabel('time index');
    ylabel('signal amplitude');
    hold on
end
%x =  x + global_burst; % add globsl burst to signal

tmp = find(global_burst>0);

x(tmp) = 0;

x =  x + global_burst; % add globsl burst to signal
x = x./norm(x,2);
if visual
    subplot(2,1,2)
    plot(x);
    title('Input Signal with global burst');
    xlabel('time index');
    ylabel('signal amplitude');
end