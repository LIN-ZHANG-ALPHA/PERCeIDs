



function  [Fac_PCD_L1,PCD_L1_exta] =  detect_community_PCD(W_tensor,opts,opts_pcd)


sz=size(W_tensor);
N = sz(1);
T = sz(3);


% initialization 
Hinit{1} = rand( N, opts.K ); 
Hinit{2} = rand( N, opts.K );
Hinit{3} = rand( T, opts.K );
for d = 1:3
    Hinit{d} = Hinit{d} / diag( sqrt( sum( Hinit{d}.^2 ) ) );
end


opts_pcd.Hinit          = Hinit;
opts_pcd.norm_method    = 'l1_norm'; %'cvx';, L1_ norm, L2_norm

[Fac_PCD_L1,PCD_L1_exta.Y_L1,PCD_L1_exta.O_L1,PCD_L1_exta.Phi_L1,PCD_L1_exta.Energ_period_L1] = PERCeIDs(W_tensor,opts.K,opts_pcd);




