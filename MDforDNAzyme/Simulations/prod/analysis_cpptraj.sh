#!/usr/bin/env bash

module load amber/amber22_ambertools23

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

$AMBERHOME/bin/cpptraj -p ../../systemPreparation/tleap/complex.parm7 << EOF
trajin md_nvt_prod-1.rst7
autoimage
trajout md_nvt_prod-1.pdb
EOF

$AMBERHOME/bin/cpptraj -p ../../systemPreparation/tleap/complex.parm7 << EOF
trajin md_nvt_prod-5.rst7
autoimage
trajout md_nvt_prod-5.pdb
EOF

$AMBERHOME/bin/cpptraj -p ../../systemPreparation/tleap/complex.parm7 << EOF
trajin md_nvt_prod-10.rst7
autoimage
trajout md_nvt_prod-10.pdb
EOF
