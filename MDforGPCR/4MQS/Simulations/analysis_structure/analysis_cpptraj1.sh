#!/usr/bin/env bash

module load amber/amber22_ambertools23

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

$AMBERHOME/bin/cpptraj -p ../complex.parm7 << EOF
trajin ../02_Min.rst7
autoimage
trajout 02_Min_ascii.pdb
EOF

$AMBERHOME/bin/cpptraj -p ../complex.parm7 << EOF
trajin ../04_Heat.rst7
autoimage
trajout 04_Heat_ascii.pdb
EOF

$AMBERHOME/bin/cpptraj -p ../complex.parm7 << EOF
trajin ../07_Prod.rst7
autoimage
trajout 07_Prod_ascii.pdb
EOF

$AMBERHOME/bin/cpptraj -p ../complex.parm7 << EOF
trajin ../08_Long.rst7
autoimage
trajout 08_Long_ascii.pdb
EOF

$AMBERHOME/bin/cpptraj -p ../complex.parm7 << EOF
trajin ../08_Long.nc 1 last 1
autoimage
trajout 08_Long_autoimage_first_last.pdb pdb onlyframes 1,25000
EOF

$AMBERHOME/bin/cpptraj -p ../complex.parm7 << EOF
trajin ../07_Prod.nc 100 last 100
trajin ../08_Long.nc 50 last 50
reference ../complex.rst7 [initial]
autoimage
rms ToInitial :2-278@CA ref [initial] mass
atomicfluct RMSF out rmsf_backbone_raw.dat @C,CA,N byres
EOF
