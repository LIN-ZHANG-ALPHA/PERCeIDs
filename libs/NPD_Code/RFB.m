function [ ] = RFB(x,Pmax, Rcq, Rav, Th)
% RFB(x,Pmax, Rcq, Rav, Th) generates a period vs time plot for the signal 
% contained in the vector x.
% Vector x can be a row or a column vector. 
% Pmax = the largest expected period.
% Rcq = Number of repeats in each Ramanujan filter
% Rav = Number of repeats in each averaging filter
% Th = Outputs of the RFB are thresholded to zero for all values less than
% Th*max(output);

%The relevant papers are:

% [] S.V. Tenneti and P. P. Vaidyanathan, "Ramanujan Filter Banks for Estimation 
% and Tracking of Periodicity", Proc. IEEE Int. Conf. Acoust. 
% Speech, and Signal Proc., Brisbane, April 2015.

% [] P.P. Vaidyanathan and S.V. Tenneti, "Properties of Ramanujan Filter Banks", 
% Proc. European Signal Processing Conference, France, August 2015.



% Copyright (c) 2015, California Institute of Technology. [Based on
% research sponsored by ONR.] All rights reserved.
% Based on work from the lab of P P Vaidyanathan.
% Code developed by Srikanth V. Tenneti.

% No-endorsement clause: Neither the name of the California Institute 
% of Technology (Caltech) nor the names of its contributors may be used to 
% endorse or promote products derived from this software without specific 
% prior written permission.

% Disclaimer: THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 
% CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, 
% BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
% FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
% HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
% TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
% EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

if((size(x,1))<(size(x,2)))
    x = x';
end


Penalty = ones(Pmax,1); % Peanlty function. Can be (optionally) used to set preference 
% to a certain set of periods in the time vs period plane.  


%% Constructing the Filter Bank

FR = cell(Pmax,1); %The set of Ramanujan Filters
FA = cell(Pmax,1); %The set of Averaging Filters

for i = 1:Pmax
    
    cq = zeros(i,1); % cq shall be the ith ramanujan sum sequnece.
    
    k_orig = 1:i; k = k_orig(gcd(k_orig,i)==1);
    for n = 0:(i-1)
     for a = k
      cq(n+1) = cq(n+1) + exp(1j*2*pi*a*(n)/i);
     end
    end
    cq=real(cq);

    FR{i,1} = repmat(cq,Rcq,1);
    FR{i,1} = FR{i,1}./norm(FR{i,1});
    FA{i,1} = repmat(ones(i,1),Rav,1);
    FA{i,1} = FA{i,1}./norm(FA{i,1});
end

% Computing the Outputs of the Filter Bank

y = zeros(length(x),Pmax);

for i = 1:Pmax
    y_temp = conv(x,FR{i,1},'same'); 
    y_temp = (abs(y_temp)).^2;
    y_temp = y_temp./Penalty(i);
    y_temp = conv(y_temp,FA{i,1},'same');
    y(:,i) = y_temp;
end

% Thresholding the output

y(:,1) = 0; % Periods 1 and 2 give strong features on the time vs period planes. Hence, zeroing them out to view the other periods better. 
y = y-min(y(:));
y = y./max(y(:));
y(y<Th)=0;



figure;imagesc(y');
colormap(jet); colorbar;
title('Time-Period Plot Using RFB');
xlabel('Time');
ylabel('Period');
end










