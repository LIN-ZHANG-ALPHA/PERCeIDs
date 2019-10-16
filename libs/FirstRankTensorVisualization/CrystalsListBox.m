%Initalization of Crystals Listbox
%Written by Jacob Zorn
%The Pennsylvania State University
%Missouri University of Science and Technology
%8/25/2017
%Version 1.0.0
%------------------------------------------------------------------------------
Crystals = {'1','1-bar','2','m','2/m','222','mm2','mmm','3','3-bar','32','3m','3-bar m','4','4-bar',...
  '4/m','422','4mm','4-bar 2m','4/mmm','6','6-bar','6/m','622','6mm','6-bar m2','6/mmm','23','m3','432','4-bar 3m','m3m','Infinity','Infinity m','Infinity 2','Infinity/m','Infinity/mm','Infinity Infinity','Infinity Infinity m'};

  [Crystal,v] = listdlg('PromptString','Select a crystal system:', 'SelectionMode','single','ListString',Crystals);

  %Tensors = {'Pyroelectricity','Dielectric Constant','Stress','Strain','Thermal Expansion','Piezoelectricity','Elasticity'};
  %[TensorType, v] = listdlg('PromptString','Select a tensor property:', 'SelectionMode','single','ListString', Tensors);
% 
