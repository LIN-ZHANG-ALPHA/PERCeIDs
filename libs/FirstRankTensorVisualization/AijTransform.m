%Aij Transformations
function return_value = AijTransform(FoldRotationorDegreesRotated,RotationAxis)
Axes = (RotationAxis);
switch FoldRotationorDegreesRotated
    case 2
        DegreesRotated = 180;
    case 3
        DegreesRotated = 120;
    case 4
        DegreesRotated = 90;
    case 6
        DegreesRotated = 60;
    case 1
        DegreesRotated = 0;
    otherwise
        DegreesRotated = FoldRotationorDegreesRotated;
end 
switch Axes
    case 'z'
        Aij = [cosd(DegreesRotated) sind(DegreesRotated) 0; -sind(DegreesRotated) cosd(DegreesRotated) 0; 0 0 1];
    case 'y'
        Aij = [cosd(DegreesRotated) 0 sind(DegreesRotated); 0 1 0; -sind(DegreesRotated) 0 cosd(DegreesRotated)];
    case 'x'
        Aij =[1 0 0; 0 cosd(DegreesRotated) sind(DegreesRotated); 0 -sind(DegreesRotated) cosd(DegreesRotated) ;];
end

return_value = Aij;
