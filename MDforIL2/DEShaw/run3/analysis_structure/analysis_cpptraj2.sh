#!/usr/bin/env bash

module load amber/amber22_ambertools23

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

$AMBERHOME/bin/cpptraj -p ../complex.parm7 << EOF
trajin ../prod-1.nc 100 last 100
trajin ../prod-2.nc 100 last 100
trajin ../prod-3.nc 100 last 100
trajin ../prod-4.nc 100 last 100
trajin ../prod-5.nc 100 last 100
trajin ../prod-6.nc 100 last 100
trajin ../prod-7.nc 100 last 100
trajin ../prod-8.nc 100 last 100
trajin ../prod-9.nc 100 last 100
trajin ../prod-10.nc 100 last 100
reference ../complex.rst7 [initial]
autoimage
rms ToInitial :6-25,31-45,48-65,80-95,100-125@CA ref [initial] mass
rms ToInitial1 :2-128@CA ref [initial] out IL2_CA_rmsd.dat mass nofit
rms ToInitial2 :1&!(@H=) ref [initial] out SP4206_rmsd.dat mass nofit
distance EndToEnd out end-to-end_dist.dat :2@CA :128@CA
radgyr RoG :2-128&!(@H=) out radius-of-gyration.dat mass nomax
atomicfluct RMSF out rmsf_backbone.dat @C,CA,N byres
trajout prods_rms_first_last.pdb pdb onlyframes 1,5000
EOF

$AMBERHOME/bin/cpptraj -p ../complex.parm7 << EOF
trajin ../prod-1.nc 100 last 100
trajin ../prod-2.nc 100 last 100
trajin ../prod-3.nc 100 last 100
trajin ../prod-4.nc 100 last 100
trajin ../prod-5.nc 100 last 100
trajin ../prod-6.nc 100 last 100
trajin ../prod-7.nc 100 last 100
trajin ../prod-8.nc 100 last 100
trajin ../prod-9.nc 100 last 100
trajin ../prod-10.nc 100 last 100
reference ../complex.rst7 [initial]
autoimage
strip :Cl-
strip :Na+
strip :WAT
rms ToInitial :6-25,31-45,48-65,80-95,100-125@CA ref [initial] mass
trajout prods_solute_rms.pdb pdb
EOF

$AMBERHOME/bin/cpptraj -p ../complex.parm7 << EOF
parmstrip :Cl-
parmstrip :Na+
parmstrip :WAT
parmwrite out complex_solute.parm7
go
exit
EOF
