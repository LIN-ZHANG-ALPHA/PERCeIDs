Instructions for the Matlab Code for Ramanujan Filter Bank.
There are two files here. These are as follows:

1. Demo_RFB.m 

Description: This is a script file that generates a random periodic 
test signal and plots the corresponding time vs period plots using 
RFB.m (explained next).

2. RFB.m 

Description: RFB(x,Pmax, Rcq, Rav, Th) generates a period vs time plot for the signal 
contained in the vector x.

Vector x can be a row or a column vector. 
Pmax = the largest expected period.
Rcq = Number of repeats in each Ramanujan filter (Higher Rcq gives better period estimate but lower time resolution)
Rav = Number of repeats in each averaging filter (Higher Rav gives smoother time vs period planes)
Th = Outputs of the RFB are thresholded to zero for all values less than Th*max(output); 

The relevant papers are:

S.V. Tenneti and P. P. Vaidyanathan, "Ramanujan Filter Banks for Estimation and Tracking of Periodicity", Proc. IEEE Int. Conf. Acoust. Speech, and Signal Proc., Brisbane, April 2015.

P.P. Vaidyanathan and S.V. Tenneti, "Properties of Ramanujan Filter Banks", Proc. European Signal Processing Conference, France, August 2015.

