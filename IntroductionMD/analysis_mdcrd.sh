#!/usr/bin/env bash

module load amber/amber22_ambertools23

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

$AMBERHOME/bin/cpptraj -p complex.parm7 << EOF
trajin prod.nc 1 last 1
autoimage
trajout prod.mdcrd
EOF
