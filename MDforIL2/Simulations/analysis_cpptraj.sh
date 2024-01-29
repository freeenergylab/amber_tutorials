#!/usr/bin/env bash

module load amber/amber22_ambertools23

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

$AMBERHOME/bin/cpptraj -p complex.parm7 << EOF
trajin heat-3.rst7
autoimage
trajout heat-3_ascii.pdb
EOF

$AMBERHOME/bin/cpptraj -p complex.parm7 << EOF
trajin press-3.rst7
autoimage
trajout press-3_ascii.pdb
EOF

$AMBERHOME/bin/cpptraj -p complex.parm7 << EOF
trajin prod.rst7
autoimage
trajout prod_ascii.pdb
EOF

$AMBERHOME/bin/cpptraj -p complex.parm7 << EOF
trajin prod-2.rst7
autoimage
trajout prod-2_ascii.pdb
EOF

$AMBERHOME/bin/cpptraj -p complex.parm7 << EOF
trajin prod-2.nc 1 last 1
autoimage
trajout prod-2_autoimage_first_last.pdb pdb onlyframes 1,50000
EOF

$AMBERHOME/bin/cpptraj -p complex.parm7 << EOF
trajin prod-2.nc 1 last 1
reference complex.rst7 [initial]
autoimage
rms ToInitial :2-128@CA ref [initial] out IL2_CA_rmsd.dat mass
rms ToInitialR :1&!(@H=) ref [initial] out SP4206_rmsd.dat mass nofit
distance EndToEnd out end-to-end_dist.dat :2@CA :128@CA
radgyr RoG :2-128&!(@H=) out radius-of-gyration.dat mass nomax
atomicfluct RMSF out rmsf_backbone.dat @C,CA,N byres
trajout prod-2_rms_first_last.pdb pdb onlyframes 1,50000
EOF

$AMBERHOME/bin/cpptraj -p complex.parm7 << EOF
trajin prod-2.nc 1 last 50
reference complex.rst7 [initial]
rms ToInitial :2-128 ref [initial] mass
strip :Cl-
strip :Na+
strip :WAT
trajout prod-2_solute_rms.pdb pdb
EOF
