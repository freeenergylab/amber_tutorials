#!/usr/bin/env bash

module load amber/amber22_ambertools23

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

$AMBERHOME/bin/cpptraj -p ../../systemPreparation/tleap/complex.parm7 << EOF
trajin ../prod/md_nvt_prod-1.nc 10 last 10
trajin ../prod/md_nvt_prod-2.nc 10 last 10
trajin ../prod/md_nvt_prod-3.nc 10 last 10
trajin ../prod/md_nvt_prod-4.nc 10 last 10
trajin ../prod/md_nvt_prod-5.nc 10 last 10
trajin ../prod/md_nvt_prod-6.nc 10 last 10
trajin ../prod/md_nvt_prod-7.nc 10 last 10
trajin ../prod/md_nvt_prod-8.nc 10 last 10
reference ../../systemPreparation/tleap/complex.rst7 [initial]
autoimage
rms ToInitial :1-52 ref [initial] mass
atomicfluct RMSF out DNAzyme_rmsf_raw.dat :1-52 byres
go
exit
EOF
