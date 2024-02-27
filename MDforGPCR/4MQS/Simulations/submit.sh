#!/usr/bin/env bash

module load amber/amber22_ambertools23
module load cuda12.0/toolkit/12.0.1
module load openmpi/4.0.5

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

nproc=32
export CUDA_VISIBLE_DEVICES=0

export prmtop=../systemPreparation/build_membrane/tleap/complex.parm7
export inpcrd=../systemPreparation/build_membrane/tleap/complex.rst7
export hmass=../systemPreparation/build_membrane/tleap/complex_hmass.parm7

# Minimise
mpirun --oversubscribe -np $nproc $AMBERHOME/bin/pmemd.MPI -O -i 01_Min.in -o 01_Min.out -p $prmtop -c $inpcrd -r 01_Min.rst7 
$AMBERHOME/bin/pmemd.cuda -O -i 02_Min.in -o 02_Min.out -p $prmtop -c 01_Min.rst7 -r 02_Min.rst7 
# Heat
$AMBERHOME/bin/pmemd.cuda -O -i 03_Heat.in -o 03_Heat.out -p $prmtop -c 02_Min.rst7 -r 03_Heat.rst7 -x 03_Heat.nc -ref 02_Min.rst7
$AMBERHOME/bin/pmemd.cuda -O -i 04_Heat.in -o 04_Heat.out -p $prmtop -c 03_Heat.rst7 -r 04_Heat.rst7 -x 04_Heat.nc -ref 03_Heat.rst7
# 1ns NPT with Backbone atoms and ligand MOL only restrained
$AMBERHOME/bin/pmemd.cuda -O -i 05_Back.in -o 05_Back.out -p $prmtop -c 04_Heat.rst7 -r 05_Back.rst7 -x 05_Back.nc -ref 04_Heat.rst7 -inf 05_Back.info
# 1ns NPT with C-alpha atoms and ligand MOL only restrained
$AMBERHOME/bin/pmemd.cuda -O -i 06_Calpha.in -o 06_Calpha.out -p $prmtop -c 05_Back.rst7 -r 06_Calpha.rst7 -x 06_Calpha.nc -ref 05_Back.rst7 -inf 06_Calpha.info
# 100ns NPT equilibration
$AMBERHOME/bin/pmemd.cuda -O -i 07_Prod.in -o 07_Prod.out -p $prmtop -c 06_Calpha.rst7 -r 07_Prod.rst7 -x 07_Prod.nc -inf 07_Prod.info
# 500ns NPT production with HMR
$AMBERHOME/bin/pmemd.cuda -O -i 08_Long.in -o 08_Long.out -p $hmass -c 07_Prod.rst7 -r 08_Long.rst7 -x 08_Long.nc -inf 08_Long.info

echo 'MD Done!'
