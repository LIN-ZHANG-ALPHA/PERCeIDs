
function visual_tesor(a, type)

if nargin < 2
    type =1;
end

if type==1
    
    nonzeros = find(a);
    v        = a(nonzeros);
    [px,py,pz] = ind2sub(size(a),nonzeros);
    %     h = scatter3(px,py,pz,'k','.');
    %     colormap(h)
%     zscaled = pz*10;
%     %   necessary To Scale The Colour Vector
%     cn = ceil(max(zscaled));
%     %   Number Of Colors (Scale AsAppropriate)
%     cm = colormap(jet(cn));
    % Define Colormap
    % col = fliplr(pz);
    col = v; % v.^2*10000;
    figure(2)
    % scatter3(px, py, pz, [], cm(ceil(zscaled),:), 'filled')
    scatter3(px, py, pz, 2, col)
    grid on
    
    colormap(jet(100))
    %colormap(map)
else
    
    color = [0.2,0.2,0.2];
    p1 = patch(isosurface(a), 'FaceColor', color, 'EdgeColor', 'none');
    p2 = patch(isocaps(a), 'FaceColor', color, 'EdgeColor', 'none');
    
    camlight left
    camlight
    lighting gouraud
    isonormals(a, p1);
    
    grid on;
    view(3);
    camorbit(-40,0);
end
