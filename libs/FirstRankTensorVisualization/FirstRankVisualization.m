%Visualization of First Rank Tensors
%Written by Jacob Zorn
%The Pennsylvania State University
%Missouri University of Science and Technology
%8/25/2017
%Version 1.0.0
%------------------------------------------------------------------------------
%Description
%Program developed to help students see, in 3-dimensions, the magnitude
%of first rank tensors for various crystal classes. If the graph presents
%an empty graph then that crystal structure is not a crystal class
%represented by first rank tensors
%------------------------------------------------------------------------------

%Program Initalization
%------------------------------------------------------------------------------
% clc
% clear all
% close all
%------------------------------------------------------------------------------

%Program Start
%------------------------------------------------------------------------------
% source('CrystalsListBox.m') %Generate the Necessary List Box
Crystal = Crystals(1,Crystal); %Picks the crystal structure from crystal list
Crystal = char(Crystal); %Converts the crystal structure to character array
Pyro_matr = FirstRankTransform(Crystal);%Transform first rank tensor to
%appropriate matrix
FirstRankPlot %Script that asks for input and then plots 3D representation of surface
%------------------------------------------------------------------------------
%Program End
