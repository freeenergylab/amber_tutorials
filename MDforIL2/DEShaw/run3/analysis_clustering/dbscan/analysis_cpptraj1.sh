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
cluster c1 dbscan kdist 1 rms :2-128@CA
cluster c2 dbscan kdist 2 rms :2-128@CA
cluster c3 dbscan kdist 3 rms :2-128@CA
cluster c4 dbscan kdist 4 rms :2-128@CA
cluster c5 dbscan kdist 5 rms :2-128@CA
cluster c6 dbscan kdist 6 rms :2-128@CA
cluster c7 dbscan kdist 7 rms :2-128@CA
cluster c8 dbscan kdist 8 rms :2-128@CA
run
EOF
