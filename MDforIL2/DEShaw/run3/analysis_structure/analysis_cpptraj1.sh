#!/usr/bin/env bash

module load amber/amber22_ambertools23

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

$AMBERHOME/bin/cpptraj -p ../complex.parm7 << EOF
trajin ../heat-3.rst7
autoimage
trajout heat-3_ascii.pdb
EOF

$AMBERHOME/bin/cpptraj -p ../complex.parm7 << EOF
trajin ../press-3.rst7
autoimage
trajout press-3_ascii.pdb
EOF

$AMBERHOME/bin/cpptraj -p ../complex.parm7 << EOF
trajin ../relax.rst7
autoimage
trajout relax_ascii.pdb
EOF

$AMBERHOME/bin/cpptraj -p ../complex.parm7 << EOF
trajin ../prod-10.rst7
autoimage
trajout prod-10_ascii.pdb
EOF

$AMBERHOME/bin/cpptraj -p ../complex.parm7 << EOF
trajin ../prod-10.nc 1 last 1
autoimage
trajout prod-10_autoimage_first_last.pdb pdb onlyframes 1,50000
EOF

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
rms ToInitial :2-128@CA ref [initial] mass
atomicfluct RMSF out rmsf_backbone_raw.dat @C,CA,N byres
EOF
