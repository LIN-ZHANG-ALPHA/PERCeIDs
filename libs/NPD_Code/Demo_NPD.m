% This script file runs the Nested Periodic Dictionaries code provided on
% our website on randomly generated periodic signals. Strength vs period plots 
% are produced using (a) Strength_vs_Period_l1.m and (b) Strength_vs_Period_l2.m.

% The relevant paper is:
% [] S.V. Tenneti and P. P. Vaidyanathan, "Nested Periodic Matrices and Dictionaries:
% New Signal Representations for Period Estimation", IEEE Transactions on Signal 
% Processing, vol.63, no.14, pp.3736-50, July, 2015.

clear all; close all; % Clear all previous variables and close all previous windows.

% Step 0: Selection of Dictionary Parameters

Pmax = 50; %The largest period spanned by the NPDs
Dictionary_type = 'Ramanujan'; %Type of the dictionary

% Step 1: Selection of Input Signal Paparemters

Input_Periods = [3,7,11]; %Component Periods of the input signal
Input_Datalength = 100; %Datalength of the input signal
SNR = 10; %Signal to noise ratio of the input in dB


% Step 2: Generating a random input periodic signal

np = length(Input_Periods);
x = zeros(Input_Datalength,1);

for i = 1:np
x_temp = randn(Input_Periods(i),1); x_temp = repmat(x_temp,ceil(Input_Datalength/Input_Periods(i)),1); 
x_temp = x_temp(1:Input_Datalength); x_temp = x_temp./norm(x_temp,2);
x = x+x_temp;
end
x = x./norm(x,2);

figure;plot(x);
title('Input Signal Before Noise');
xlabel('time index');
ylabel('signal amplitude');

% Step 3: Adding Noise to the Input
ns = randn(Input_Datalength,1); ns = ns./norm(ns,2);
Desired_Noise_Power = 10^(-1*SNR/20);
ns = Desired_Noise_Power.*ns;
x = x + ns;
figure;plot(x);
title('Input Signal With Noise');
xlabel('time index');
ylabel('signal amplitude');

% Step 4: Producing Strength vs Period Plots using NPDs

% Strength_vs_Period_L1(x,Pmax,Dictionary_type);
Strength_vs_Period_L2(x,Pmax,Dictionary_type);

% Step 5: Comparison with Fourier Transform

[h,w] = freqz(x,1,ceil((length(x))/2));
figure;stem((2*pi./w),abs(h),'linewidth',3,'color',[0 0 0]);xlim([1 Pmax]);
title('Using Fourier Transform');
xlabel('2\pi/\omega');
ylabel('Spectrum');

% Step 6: Comparison with Ramanujan Filter Bank

RFB(x,Pmax,10,2,0.3);














