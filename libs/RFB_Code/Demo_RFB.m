% This script file runs the Ramanujan Filter Bank code provided on
% our website on sample signals exhibiting time varying periodicity. 
%The relevant papers are:

% [] S.V. Tenneti and P. P. Vaidyanathan, "Ramanujan Filter Banks for Estimation 
% and Tracking of Periodicity", Proc. IEEE Int. Conf. Acoust. 
% Speech, and Signal Proc., Brisbane, April 2015.

% [] P.P. Vaidyanathan and S.V. Tenneti, "Properties of Ramanujan Filter Banks", 
% Proc. European Signal Processing Conference, France, August 2015.


clear all; close all; % Clear all previous variables and close all previous windows.

% Step 0: Ramanujan Filter Bank Parameters

Rcq = 10; % Number of repeats in each Ramanujan filter
Rav = 2; % Number of repeats in each averaging filter
Th = 0.2; % Outputs of the RFB are thresholded to zero for all values less than Th*max(output)
Pmax = 40; % Largest expected period in the input

% Step 1: Generating input signals 

Input_Period = 10;
x1 = zeros(30,1);
x2 = randn(Input_Period,1);x2 = repmat(x2,10,1);
x3 = zeros(30,1);
x = cat(1,x1,x2,x3); x = x./norm(x,2);
figure;plot(x);
title('Input Signal before noise');
xlabel('time index');
ylabel('signal amplitude');

% Step 2: Adding Noise to the Input

SNR = 0; % SNR in dB
ns = randn(length(x),1); ns = ns./norm(ns,2);
Desired_Noise_Power = 10^(-1*SNR/20);
ns = Desired_Noise_Power.*ns;
x = x + ns;
figure;plot(x);
title('Input Signal with noise');
xlabel('time index');
ylabel('signal amplitude');

% Step 3: Period vs Time Planes Using the RFB

RFB(x,Pmax, Rcq, Rav, Th);













