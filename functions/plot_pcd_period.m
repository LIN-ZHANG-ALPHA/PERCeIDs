

function plot_pcd_period(Energ_period,Y,Pmax,line_size)

if nargin < 4
    line_size = 3;
end


[m,n] =  size(Energ_period); % m: number of basis, n: number of community

figure;
for i =  1: n
    subplot(n,1,i)
    energy_s  =  Energ_period(:,i)./norm(Energ_period(:,i));
    %     y = abs(Y(:,i));
    %     plot(x,y(1:20),'LineWidth', line_size); hold on
    stem(energy_s,'linewidth',line_size); %,'color',[0 0 0]);
    % title('l1 norm minimization');
    xlabel('Period');
    ylabel('Strength');
end
sgtitle('Using  NPM')

%% FT

% figure;
% for i =  1: n
%     subplot(n,1,i)
%     x= Y(:,i);
%     [h,w] = freqz(x,1,ceil((length(x))/2));
%     
%     stem((2*pi./w),abs(h),'linewidth',3,'color',[0 0 0]);xlim([1 Pmax]);
% 
%     xlabel('2\pi/\omega');
%     ylabel('Spectrum');
%     
% end
%  sgtitle('Using Fourier Transform');
 
 