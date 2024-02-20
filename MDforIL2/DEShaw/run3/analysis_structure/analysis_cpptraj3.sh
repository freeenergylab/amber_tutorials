#!/usr/bin/env bash

module load amber/amber22_ambertools23

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

$AMBERHOME/bin/cpptraj -p complex_solute.parm7 << EOF
trajin prods_solute_rms.pdb 1 last 1
reference ../../../1PY2/Simulations/prod_ascii_solute.pdb [initial]
rms ToInitial :6-25,31-45,48-65,80-95,100-125@CA ref [initial] mass
rms ToInitial1 :2-128@CA ref [initial] out IL2_CA_rmsd2bound.dat mass nofit
rms ToInitial2 :1&!(@H=) ref [initial] out SP4206_rmsd2bound.dat mass nofit
trajout prods_solute_rms2bound.pdb pdb
EOF
