#!/usr/bin/env bash

module load amber/amber22_ambertools23

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

$AMBERHOME/bin/cpptraj -p ../complex.parm7 << EOF
trajin ../07_Prod.nc 100 last 100
trajin ../08_Long.nc 50 last 50
reference ../complex.rst7 [initial]
autoimage
rms ToInitial :8-192,208-272@CA ref [initial] mass
rms ToInitial1 :2-278@CA ref [initial] out 4MQS_CA_rmsd.dat mass nofit
rms ToInitial2 :1&!(@H=) ref [initial] out IXO_rmsd.dat mass nofit
distance EndToEnd out end-to-end_dist.dat :2@CA :278@CA
radgyr RoG :2-278&!(@H=) out radius-of-gyration.dat mass nomax
atomicfluct RMSF out rmsf_backbone.dat @C,CA,N byres
trajout prods_rms_first_last.pdb pdb onlyframes 1,600
EOF

$AMBERHOME/bin/cpptraj -p ../complex.parm7 << EOF
trajin ../07_Prod.nc 100 last 100
trajin ../08_Long.nc 50 last 50
reference ../complex.rst7 [initial]
autoimage
strip :Cl-
strip :Na+
strip :WAT
strip :PA
strip :PC
strip :OL
strip :CHL
rms ToInitial :8-192,208-272@CA ref [initial] mass
trajout prods_solute_rms.pdb pdb
EOF
