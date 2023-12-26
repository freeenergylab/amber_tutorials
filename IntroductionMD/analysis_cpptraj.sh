#!/usr/bin/env bash

module load amber/amber22_ambertools23

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

$AMBERHOME/bin/cpptraj -p complex.parm7 << EOF
trajin complex.rst7
trajin prod.nc 1 last 1
autoimage
trajout prod_autoimage.crd
trajout prod_autoimage_first_last.pdb pdb onlyframes 1,200
EOF

$AMBERHOME/bin/cpptraj -p complex.parm7 << EOF
trajin prod_autoimage.crd 1 last 1
reference complex.rst7 [initial]
rms ToInitial :1-14@CA ref [initial] out singleparticle_CA_rmsd.dat mass
rms ToInitialL :1-6@CA ref [initial] out single_CA_rmsd.dat mass nofit
rms ToInitialR :7-14@CA ref [initial] out particle_CA_rmsd.dat mass nofit
distance EndToEnd out end-to-end_dist.dat :1@CA :14@CA
radgyr RoG :1-14&!(@H=) out radius-of-gyration.dat mass nomax
atomicfluct RMSF out rmsf_backbone.dat @C,CA,N byres
trajout prod_rms.crd
trajout prod_rms_first_last.pdb pdb onlyframes 1,200
EOF


