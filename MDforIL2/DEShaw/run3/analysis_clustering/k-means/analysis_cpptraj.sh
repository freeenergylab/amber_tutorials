#!/usr/bin/env bash

module load amber/amber22_ambertools23

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

$AMBERHOME/bin/cpptraj -p ../../complex.parm7 << EOF
trajin ../../prod-1.nc 50 last 50
trajin ../../prod-2.nc 50 last 50
trajin ../../prod-3.nc 50 last 50
trajin ../../prod-4.nc 50 last 50
trajin ../../prod-5.nc 50 last 50
trajin ../../prod-6.nc 50 last 50
trajin ../../prod-7.nc 50 last 50
trajin ../../prod-8.nc 50 last 50
trajin ../../prod-9.nc 50 last 50
trajin ../../prod-10.nc 50 last 50
reference ../../complex.rst7 [initial]
autoimage
strip :Cl-
strip :Na+
strip :WAT
rms ToInitial :2-128@CA ref [initial] mass
cluster Cluster1  kmeans clusters 10  randompoint  maxit 500  rms :2-128@CA  sieve 10 random  out clustersnum_vs_time.dat  summary summary.dat  info info.dat  cpopvtime clusterspop_vs_time.agr normframe  repout rep repfmt pdb  singlerepout singlerep.pdb singlerepfmt pdb  avgout avg avgfmt pdb
run
EOF
