#!/usr/bin/env bash

module load amber/amber24_ambertools24

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

$AMBERHOME/bin/cpptraj -p ../solvated.parm7 << EOF
trajin prod.mdcrd
hbond HB out nhb.dat avgout solute_avg.dat solventacceptor :WAT@O solventdonor :WAT solvout solvent_avg.dat bridgeout bridge.dat series uuseries uuhbonds.agr uvseries uvhbonds.agr
EOF
