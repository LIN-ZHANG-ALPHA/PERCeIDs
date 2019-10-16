% INPUT:
% - T: m x n x r input tensor
% - TL: list form of T (create this by running tensor2list on T)
% - k: number of components
% - s: period (e.g. 7 for daily data with weekly seasonality)
% - alpha: learning rate
% - init_cycles: number of seasons to use for initialization (3 is
% recommended)
% - output_anom: pass in true to output anomaly detection results, which is
% the matrix E

% OUTPUT:
% - U: a cell array with 2 components: U{1} is an m x k matrix which is the
% 1st component, while U{2} is a n x k matrix which is the 2nd component.
% These correspond to U and V from the paper.
% - W: r by k matrix of seasonal multipliers (corresponding to W in the
% paper). W(t,:) is the vector of seasonal multipliers at time t.
% - E: anomaly detection output. E(i,t) is the anomalousness of entity i in
% the first mode at time t. (to investigate the 2nd mode, just transpose
% the input tensor to swap mode 1 and 2)

function [U, W, E] = smf(T, TL, k, s, alpha, init_cycles, output_anom)

Tsz = size(T);
nmodes = length(Tsz) - 1;
ntimes = size(T, 3);
if output_anom
    E = nan(Tsz(1), ntimes);
else
    E = [];
end
T_init = T(:,:,1:s*init_cycles);
nz_tmod = mod(T_init.subs(:,3)-1, s)+1;
Tmod = sptensor([T_init.subs(:,1:2) nz_tmod], T_init.vals, [Tsz(1:2) s]) / init_cycles;

[U_init, ~] = ncp(Tmod, k, struct('maxit', 5));
W = nan(s + ntimes, k);

W(1:s, :) = U_init.U{nmodes + 1};
for i=1:nmodes
    weights = sqrt(sum(U_init.U{i}.^2, 1));
    U{i} = U_init.U{i} * diag(1 ./ weights);
    W(1:s, :) = W(1:s, :) * diag(weights);
end

for t=1:ntimes
    At = TL{t};
    D = sparse(diag(W(t,:)));
    
    grad = {At * U{2} * D - U{1} * D * (U{2}' * U{2}) * D, ...
        At' * U{1} * D - U{2} * D * (U{1}' * U{1}) * D};
    
    Wfit = W(t,:);
    
    for i=1:nmodes
        grad{i} = grad{i} * min(1, alpha * sqrt(k) / sqrt(sum(sum(grad{i}.^2))));
        U{i} = U{i} + alpha * grad{i};
        weights = sqrt(sum(U{i}.^2, 1));
        U{i} = U{i} * sparse(diag(1 ./ weights));
        U{i} = max(0, U{i});
        Wfit = Wfit .* weights;
    end
    W(t+s,:) = Wfit;
    
    if output_anom
        D = sparse(diag(Wfit));
        WVVW = D * U{2}' * U{2} * D;
        for i = 1:Tsz(1)
            ui = U{1}(i, :);
            E(i, t) = ui * WVVW * ui';
        end
        [ii, jj, vv] = find(TL{t});
        for j = 1:length(ii)
            r = ii(j);
            c = jj(j);
            Aobs = vv(j);
            Ahat = sum(U{1}(r, :) .* Wfit .* U{2}(c, :));
            E(r, t) = E(r, t) + (Aobs - Ahat)^2 - Ahat^2;
        end
    end
   
end
W(1:s, :) = [];