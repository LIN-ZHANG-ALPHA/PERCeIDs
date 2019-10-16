Instructions for the Matlab code on NPDs. 

There are five files here. These are as follows:

1. Demo_NPD.m 

Please Note: This program needs you to install the cvx package (http://cvxr.com/cvx/) 
for being able to solve the L1 convex program.

Description: This script file runs the Nested Periodic Dictionaries code provides a demo
of the period estimation using Nested Periodic Dictionaries on a randomly generated test 
periodic signal. Strength vs period plots are produced using 
(a) Strength_vs_Period_l1.m and (b) Strength_vs_Period_l2.m. (explained next)


2. Strength_vs_Period_L1.m 

Please Note: This program needs you to install the cvx package (http://cvxr.com/cvx/) 
for being able to solve the L1 convex program.

Description: Strength_vs_Period_L1(x,Pmax,method) plots the strength vs period plot for the
signal x using an L1 norm based convex program. 

Pmax is the largest expected period in the signal. 

method indicates the type of dictionary to be used. 
method = 'random' or 'Ramanujan' or 'NaturalBasis' or 'DFT'.
%'random' gives a random NPD.
%'Ramanujan' gives the Ramanujan NPD.
%'NaturalBasis' gives the Natural Basis NPD.
%'Farey' gives the Farey NPD.


3. Strength_vs_Period_L2.m 

Description: Strength_vs_Period_L2(x,Pmax,method) plots the strength vs period plot for the
signal x using an L2 norm based convex program. 

Pmax is the largest expected period in the signal. 

method indicates the type of dictionary to be used. 
method = 'random' or 'Ramanujan' or 'NaturalBasis' or 'DFT'.
%'random' gives a random NPD.
%'Ramanujan' gives the Ramanujan NPD.
%'NaturalBasis' gives the Natural Basis NPD.
%'Farey' gives the Farey NPD.



4. Create_Dictionary.m

Description: Create_Dictionary(Nmax,rowSize,method) retruns a dictionary matrix with 
maximum expected Period = Nmax, and rowSize number of rows.

method = 'random' or 'Ramanujan' or 'NaturalBasis' or 'DFT'.
%'random' gives a random NPD.
%'Ramanujan' gives the Ramanujan NPD.
%'NaturalBasis' gives the Natural Basis NPD.
%'Farey' gives the Farey NPD.


5. RFB.m 

Description: RFB(x,Pmax, Rcq, Rav, Th) generates a period vs time plot for the signal 
contained in the vector x. (Please see the section on Ramanujan Filter Banks on our website.)

Vector x can be a row or a column vector. 
Pmax = the largest expected period.
Rcq = Number of repeats in each Ramanujan filter (Higher Rcq gives better period estimate but lower time resolution)
Rav = Number of repeats in each averaging filter (Higher Rav gives smoother time vs period planes)
Th = Outputs of the RFB are thresholded to zero for all values less than Th*max(output); 


% The relevant paper is:
% [] S.V. Tenneti and P. P. Vaidyanathan, "Nested Periodic Matrices and Dictionaries:
% New Signal Representations for Period Estimation", IEEE Transactions on Signal 
% Processing, vol.63, no.14, pp.3736-50, July, 2015.


