%Mirror Plane Function
function return_value = MirrorPlane(PerpendicularAxis)
switch PerpendicularAxis
  case 'x', 'X'
    Aij = [-1 0 0; 0 1 0; 0 0 1];
  case 'y', 'Y'
    Aij = [1 0 0; 0 -1 0; 0 0 1];
  case 'z', 'Z'
    Aij = [1 0 0; 0 1 0; 0 0 -1];
end

return_value = Aij;