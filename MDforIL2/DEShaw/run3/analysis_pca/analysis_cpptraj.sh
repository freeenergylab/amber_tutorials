#!/usr/bin/env bash

module load amber/amber22_ambertools23

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

$AMBERHOME/bin/cpptraj -p ../complex.parm7 << EOF
trajin ../prod-1.nc 50 last 50
trajin ../prod-2.nc 50 last 50
trajin ../prod-3.nc 50 last 50
trajin ../prod-4.nc 50 last 50
trajin ../prod-5.nc 50 last 50
trajin ../prod-6.nc 50 last 50
trajin ../prod-7.nc 50 last 50
trajin ../prod-8.nc 50 last 50
trajin ../prod-9.nc 50 last 50
trajin ../prod-10.nc 50 last 50
reference ../complex.rst7 [initial]
autoimage
strip :Cl-
strip :Na+
strip :WAT
rms ToInitial :2-128@CA ref [initial] mass
average crdset [TrajAvg] 
createcrd AllTrajs
run
crdaction AllTrajs rms ToAvg :2-128@CA ref [TrajAvg] mass
crdaction AllTrajs matrix covar name TrajCovar :2-128@CA
runanalysis diagmatrix TrajCovar out eigen_results.dat vecs 3 name MyEvecs nmwiz nmwizvecs 3 nmwizfile output_NMWiz.nmd nmwizmask :2-128@CA
crdaction AllTrajs projection MyProjection evecs MyEvecs out projection_results.dat beg 1 end 3 :2-128@CA
hist MyProjection:1 bins 100 out projection-1_hist.dat norm name Projection-1
hist MyProjection:2 bins 100 out projection-2_hist.dat norm name Projection-2
hist MyProjection:3 bins 100 out projection-3_hist.dat norm name Projection-3
run
EOF

$AMBERHOME/bin/cpptraj -p ../complex.parm7 << EOF
parmstrip !(:2-128@CA)
parmwrite out complex_pca_modes.parm7 
go
exit
EOF

$AMBERHOME/bin/cpptraj -p ../complex.parm7 << EOF
readdata eigen_results.dat name MyEvecs
runanalysis modes name MyEvecs trajout projection_mode1.pdb pcmin -20 pcmax 20 tmode 1 trajoutmask :2-128@CA trajoutfmt pdb
runanalysis modes name MyEvecs trajout projection_mode2.pdb pcmin -20 pcmax 20 tmode 2 trajoutmask :2-128@CA trajoutfmt pdb
runanalysis modes name MyEvecs trajout projection_mode3.pdb pcmin -20 pcmax 20 tmode 3 trajoutmask :2-128@CA trajoutfmt pdb
EOF
