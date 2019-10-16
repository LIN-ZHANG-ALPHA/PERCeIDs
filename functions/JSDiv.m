function div = JSDiv(P, Q)
% Hence, we apply a metric alternative Jansen-Shannon divergence (DIV) [48] 
% that handles 0 probabilities and varies between 0 (no divergence) and 1.

    P_norm = P/sum(P);
	Q_norm = Q/sum(Q);
	M = 0.5*(P_norm+Q_norm);
    KLDP = sum(arrayfun(@safeLogProd, P_norm, M));
    KLDQ = sum(arrayfun(@safeLogProd, Q_norm, M));
    
    div = 0.5*(KLDP + KLDQ);
end
