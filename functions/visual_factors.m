

function  visual_factors(idx,opts_syndata,m,n,line_size,Fac_pcd,Fac_Larc,Fac_cp,image_path,filename)

% idx = 1;
% m = 1; n = 4;
% line_size  = 3;
% x            = 1:opts_syndata.N1 *opts_syndata.K;
x            = 1:size( Fac_pcd{idx},1);
y_pcd     =  Fac_pcd{idx};
y_larc    =  Fac_Larc{idx};
y_cp       =  Fac_cp{idx};
% y_nmf     =  Fac_nmf{idx};

% d   = 3;                % # mixed observations
% r   = 3;                % # independent/principal components

% cm = hsv(max([3, r, d]));
cm = hsv(max([3, opts_syndata.K, opts_syndata.K]));


h = figure;
ax1 = subplot(n,m,1) ;
% plot(x,y_pcd(:,1),'color',[0         0.4470    0.7410],'LineWidth', line_size); hold on
% plot(x,y_pcd(:,1),x,y_pcd(:,2),x,y_pcd(:,3),'LineWidth', line_size); hold on
% plot(x,y_pcd(:,1),x,y_pcd(:,2),x,y_pcd(:,3),x,y_pcd(:,4),x,y_pcd(:,5),'LineWidth', line_size); hold on
for i =  1:opts_syndata.K
    % plot(x,y_pcd(:,i),'LineWidth', line_size, 'Color',cm(i,:)); hold on
    plot(x,y_pcd(:,i),'LineWidth', line_size); hold on
end
title(ax1,'PCD')

ax2 = subplot(n,m,2) ;
% plot(x,y_pcd(:,1),'color',[0         0.4470    0.7410],'LineWidth', line_size); hold on
% plot(x,y_larc(:,1),x,y_larc(:,2),x,y_larc(:,3),'LineWidth', line_size); hold on
% plot(x,y_larc(:,1),x,y_larc(:,2),x,y_larc(:,3),x,y_larc(:,4),x,y_larc(:,5),'LineWidth', line_size); hold on
for i =  1:opts_syndata.K
    plot(x,y_larc(:,i),'LineWidth', line_size); hold on
end
title(ax2,'LARC')

ax3 = subplot(n,m,3) ;
% plot(x,y_pcd(:,1),'color',[0         0.4470    0.7410],'LineWidth', line_size); hold on
% plot(x,y_cp(:,1),x,y_cp(:,2),x,y_cp(:,3),'LineWidth', line_size); hold on
% plot(x,y_cp(:,1),x,y_cp(:,2),x,y_cp(:,3),x,y_cp(:,4),x,y_cp(:,5),'LineWidth', line_size); hold on
for i =  1:opts_syndata.K
    plot(x,y_cp(:,i),'LineWidth', line_size); hold on
end
title(ax3,'NTF')

% if idx~=3 % NMF has no temporal profile
    ax4 = subplot(n,m,4) ;
    % plot(x,y_pcd(:,1),'color',[0         0.4470    0.7410],'LineWidth', line_size); hold on
    % plot(x,y_nmf(:,1),x,y_nmf(:,2),x,y_nmf(:,3),'LineWidth', line_size); hold on
    % plot(x,y_nmf(:,1),x,y_nmf(:,2),x,y_nmf(:,3),x,y_nmf(:,4),x,y_nmf(:,5),'LineWidth', line_size); hold on
    for i =  1:opts_syndata.K
        plot(x,y_nmf(:,i),'LineWidth', line_size); hold on
        set(gca,'YLim',[0 1])
    end
    title(ax4,'NTF')
end

if idx ==1
    sgtitle('Community detection')
elseif idx==3
    sgtitle('Temporal profile of communities')
end

if filename
    % image_path = 'demo/syndata/syn_results/';
    imagename  = [image_path,filename,'.png'];
    saveas(h,imagename)
end
% close(h)

% plot(x,udfs1, '-d','MarkerSize', 15,'color',[0.9320     0.5607    0.8722],'LineWidth', line_size);hold on% ,'LineWidth', 2);


% m = 1; n = 3;
% figure,
% subplot(m,n,1)
% imshow(Fac_pcd{1},[])
% title('PCD')
%
% subplot(m,n,2)
% imshow(Fac_Larc{1},[])
% title('LARC')
%
% subplot(m,n,3)
% imshow(abs(Fac_cp{1}),[])
% title('CP')




