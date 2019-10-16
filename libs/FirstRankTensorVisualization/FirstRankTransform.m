%Transformations of First Rank Tensors

function return_value = FirstRankTransform(Crystal)
Pyro = [1; 2; 3];
NewPyro = zeros(3,1);
switch Crystal
    case '1'
    NewPyro = AijTransform(1,'x') * Pyro;
    NewPyro = PyroCheck(NewPyro);
    case '1-bar'
    NewPyro = [-1 0 0; 0 -1 0; 0 0 -1] * Pyro;
    NewPyro = PyroCheck(NewPyro);
    case '2'
    NewPyro = AijTransform(2,'y') * Pyro;
    NewPyro = PyroCheck(NewPyro);
    case 'm' 
    NewPyro = MirrorPlane('y') * Pyro;
    NewPyro = PyroCheck(NewPyro);
    case '2/m'
    NewPyro = AijTransform(2,'y')*Pyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = MirrorPlane('y') * NewPyro;
    NewPyro = PyroCheck(NewPyro);
    case '222'
    NewPyro = AijTransform(2,'x') * Pyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = AijTransform(2,'y') * NewPyro;
    NewPyro = PyroCheck(NewPyro);
    case 'mm2'
    NewPyro = MirrorPlane('x') * Pyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = MirrorPlane('y') * NewPyro;
    case 'mmm'
    NewPyro = MirrorPlane('x') * Pyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = MirrorPlane('y') * NewPyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = MirrorPlane('z') * NewPyro;
    case '3'
    NewPyro = AijTransform(3,'z') * Pyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = PyroCheck(NewPyro);
    case '32'
    NewPyro = AijTransform(3,'z') * Pyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = AijTransform(2,'x') * NewPyro;
    case '3m'
    NewPyro = AijTransform(3,'z') * Pyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = MirrorPlane('x') * NewPyro;
    case '3-bar'
    NewPyro = (-1*AijTransform(3,'z'))*Pyro;
    case '3-bar m'
    NewPyro = (-1*AijTransform(3,'z'))*Pyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = MirrorPlane(x') * NewPyro;
    case '4'
    NewPyro = AijTransform(4,'z') * Pyro;
    case '4-bar'
    NewPyro = (-1*AijTransform(4,'z'))*Pyro;
    case '4/m'
    NewPyro = AijTransform(4,'z')*Pyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = MirrorPlane('z') * NewPyro;
    case '422'
    NewPyro = AijTransform(4,'z') * Pyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = AijTransform(2,'x') * NewPyro;
    case '4mm'
    NewPyro = AijTransform(4,'z') * Pyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = MirrorPlane('x') * NewPyro;
    case '4-bar 2m'
    NewPyro = (-1*AijTransform(4,'z'))*Pyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = AijTransform(2,'x')*NewPyro;
    case '4/mmm'
    NewPyro = AijTransform(4,'z') * Pyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = MirrorPlane('z') * NewPyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = MirrorPlane('x') * NewPyro;
    case '6'
    NewPyro = AijTransform(6,'z') * Pyro;
    case '6-bar'
    NewPyro = (-1*AijTransform(6,'z'))*Pyro;
    NewPyro = PyroCheck(NewPyro);
    case '6/m'
    NewPyro = AijTransform(6,'z') * Pyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = MirrorPlane('z') * NewPyro;
    case '622'
    NewPyro = AijTransform(6,'z') * Pyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = AijTransform(2,'x') * NewPyro;
    case '6mm'
    NewPyro = AijTransform(6,'z') * Pyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = MirrorPlane('x') * NewPyro;
    case '6-bar m2'
    NewPyro = (-1*AijTransform(6,'z'))*Pyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = MirrorPlane('x') * NewPyro;
    case '6/mmm'
    NewPyro = AijTransform(6,'z') * Pyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = MirrorPlane('z') * NewPyro;
    NewPyro = PyroCheck(NewPyro);
    NewPyro = MirrorPlane('x') * NewPyro;
    
end
NewPyro = PyroCheck(NewPyro);
return_value = NewPyro;