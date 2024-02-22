#!/usr/bin/env bash

module load amber/amber22_ambertools23

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

$AMBERHOME/bin/cpptraj -p ../../systemPreparation/tleap/complex.parm7 << EOF
trajin ../prod/md_nvt_prod-1.nc 50 last 50
trajin ../prod/md_nvt_prod-2.nc 50 last 50
trajin ../prod/md_nvt_prod-3.nc 50 last 50
trajin ../prod/md_nvt_prod-4.nc 50 last 50
trajin ../prod/md_nvt_prod-5.nc 50 last 50
trajin ../prod/md_nvt_prod-6.nc 50 last 50
trajin ../prod/md_nvt_prod-7.nc 50 last 50
trajin ../prod/md_nvt_prod-8.nc 50 last 50
reference ../../systemPreparation/tleap/complex.rst7 [initial]
autoimage
rms ToInitial :2-9,20-28,37-49 ref [initial] mass
rms ToInitial1 :1-52 ref [initial] out DNAzyme_rmsd.dat mass nofit
atomicfluct RMSF out DNAzyme_rmsf.dat :1-52 byres
for residues DRNA inmask :1-52 i=1;i++
  nativecontacts \$DRNA :MG out DNAzyme_cluster1_run1_200mM_MG_res_\$i.dat writecontacts contacts.log resout contact_res_pairs.log distance 7.0 mindist byresidue skipnative
done
strip :Na+
strip :K+
strip :Cl-
strip :WAT
trajout prods_solute_rms.pdb pdb
go
exit
EOF
