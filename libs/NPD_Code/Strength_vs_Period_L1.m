function [ ] = Strength_vs_Period_L1(x,Pmax,method)
%Strength_vs_Period_L1(x,Pmax,method) plots the strength vs period plot for the
%signal x using an L1 norm based convex program. 
%Pmax is the largest expected period in the signal. 
%method indicates the type of dictionary to be used. method = 'random' or 'Ramanujan' 
% or 'NaturalBasis' or 'DFT'.
%'random' gives a random NPD.
%'Ramanujan' gives the Ramanujan NPD.
%'NaturalBasis' gives the Natural Basis NPD.
%'Farey' gives the Farey NPD.

% The relevant paper is:
% [] S.V. Tenneti and P. P. Vaidyanathan, "Nested Periodic Matrices and Dictionaries:
% New Signal Representations for Period Estimation", IEEE Transactions on Signal 
% Processing, vol.63, no.14, pp.3736-50, July, 2015.

% Copyright (c) 2016, California Institute of Technology. [Based on
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



if(size(x,2)>size(x,1))
    x = x';
end

Nmax = Pmax;
A = Create_Dictionary(Nmax,size(x,1),method);

% for i=1:size(A,2)
%     A(:,i) = A(:,i)./norm(A(:,i));
% end


% Penalty Vector Calculation

penalty_vector = [];
for i=1:Nmax
    k=1:i;k_red=k(gcd(k,i)==1);k_red=length(k_red);
    penalty_vector=cat(1,penalty_vector,i*ones(k_red,1));
end

  penalty_vector = penalty_vector.^2;
%   penalty_vector = 1+0.*penalty_vector; %Use this if you do not want to
%  use penalty vector

if((isreal(x)==0)||strcmp(method,'Farey'))
cvx_begin
variable s(size(A,2)) complex
minimize(norm(penalty_vector.*s,1))
subject to
x==A*s;
cvx_end
else
cvx_begin
variable s(size(A,2))
minimize(norm(penalty_vector.*s,1))
subject to
x==A*s;
cvx_end
end

energy_s = 0.*[1:Nmax];
current_index_end = 0;
for i=1:Nmax
    k_orig = 1:i;k=k_orig(gcd(k_orig,i)==1);
    current_index_start = current_index_end + 1;
    current_index_end = current_index_end + size(k,2);
    
    for j=current_index_start:current_index_end
    
    energy_s(i) = energy_s(i)+((abs(s(j)))^2);
    end
    
end

energy_s(1) = 0;
figure;stem(energy_s,'linewidth',3,'color',[0 0 0]);
title('l1 norm minimization');
xlabel('Period');
ylabel('Strength');

end

