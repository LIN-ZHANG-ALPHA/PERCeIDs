%PyroTensor Check

function return_value = PyroCheck(NewPyroTensor)
Pyro = [1;2;3];
for i = 1:3
  if NewPyroTensor(i,1) == Pyro(i,1);
  else NewPyroTensor(i,1) = 0;
  end
end
return_value = NewPyroTensor;
