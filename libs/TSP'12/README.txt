=code=

SC_SR.m: implementation of the SC_SR algorithm
SC_SED.m: implementation of the SC_SED algorithm (in the TSP paper)

/function/regul_graph.m: function to implement regularization process on graphs
/function/comeig_lbfgs.m: function needed to implement L-BFGS based optimization
/function/comeig_lbfgs2.m: function needed to implement L-BFGS based optimization
/function/locfn: other functions that may be needed

/toolbox/lbfgs: MATLAB implementation of L-BFGS, downloadable at:
http://www.cs.grinnell.edu/~weinman/code/.
/toolbox/sgwt_toolbox: MATLAB implementation of Spectral Graph Wavelet Toolbox, 
downloadable at: http://wiki.epfl.ch/sgwt/.

=data=

/data/synthetic.mat: synthetic dataset
/data/nrc.mat: NRC dataset
/data/cora.mat: Cora dataset

In each of the MATLAB file, the variables are:
A: multi-layer graph
C: groundtruth clustering
K: number of clusters