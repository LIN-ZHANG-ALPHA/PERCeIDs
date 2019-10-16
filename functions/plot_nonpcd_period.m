



function plot_nonpcd_period(TT,Pmax)

% if nargin < 3
%     line_size = 3;
% end



[m,n] =  size(TT); % m: number of basis, n: number of community
if m < n
    TT = TT';
end

num_comm =  min(m,n);

figure;
for i =  1: num_comm
    subplot(num_comm,1,i)
    x= TT(:,i);
    [h,w] = freqz(x,1,ceil((length(x))/2));
    h = h./norm(h)*10;
    stem((2*pi./w),abs(h),'linewidth',3,'color',[0 0 0]);xlim([1 Pmax]);

    xlabel('2\pi/\omega');
    ylabel('Spectrum');
    
end
 sgtitle('Using Fourier Transform');
 
 