%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This is a demo file that computes the CP decomposition           %%
%% of multy-way tensors with iterative deflation                   %%
%%                                                                  %%
%%   Features:                                                      %%
%%     - Real and complex tensors                                   %%
%%     - Order N implemented                                        %%
%%     - Options of rank-one approx.: T-HOSVD ans SeROAP            %%   
%%     - Option for Gaussian noise                                  %%
%%                                                                  %%
%%   Input:                                                         %%   
%%     - Tn: input tensor (possibly corrupted by noise)             %%
%%     - R: rank  of the unoised tensor                             %%
%%     - Itr_max: maximum number of iterations in the simulation    %%
%%     - tol: Precision of the approximation                        %%
%%     - funcMethod: rank-one approx. method (T-HOSVD or SeROAP)    %%   
%%                                                                  %%
%%   Output:                                                        %%
%%     - Xr: rank one components                                    %%
%%     - Er: residual                                               %%
%%                                                                  %%
%%                                                                  %%
%% Written by Alex P. da Silva, P. Comon and A.L.F de Almeida on    %%
%% April, 7th 2015                                                  %%
%% Modified on August, 24th 2015                                    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clc
% close all
% clear all

% Dimensions
dims = [2 2 2];
% Rank
R = 3;

%Set Noise
flagNoise = 0;

% Noise Level (for flagNoise = 1)
SNR_dB = 40;

%Set complex tensors ( 0 --> real tensors)
flagComplex = 0;

% rank-1 approximation method; SeROAP or THOSVD
funcMethod = @SeROAP;

% Stopping criteria
tol = 1e-6;
itr_max = 500;

% Generate a rank R tensor
T = generateTensor(dims,R, flagComplex);

% Signal Power
P_signal = norm(T(:))^2/numel(T(:));

%Include Noise
if flagNoise == 1
    varNoise = P_signal*10^(-SNR_dB/10);
    
    No = (randn(dims(1),dims(2),dims(3))) +j*flagComplex*(randn(dims(1),dims(2),dims(3)));
    N = sqrt(varNoise/(1+flagComplex))*No;
else
    N = 0;
end
Tn = T + N;

% dcpd algorithm
[Xr,Er]=dcpd(Tn,R,itr_max,tol,funcMethod);

disp('end');

