#!/usr/bin/env bash

module load amber/amber22_ambertools23
module load cuda12.0/toolkit/12.0.1
module load openmpi/4.0.5

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

nproc=32
PRMTOP=../../systemPreparation/tleap/complex.parm7
INPCRD=../../systemPreparation/tleap/complex.rst7

OLD=$INPCRD
NEW=min_ntr_h
mpirun --oversubscribe -np $nproc $AMBERHOME/bin/pmemd.MPI -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -inf $NEW.info

OLD=$NEW.rst7
NEW=min_ntr_l
mpirun --oversubscribe -np $nproc $AMBERHOME/bin/pmemd.MPI -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -inf $NEW.info

OLD=$NEW.rst7
NEW=min_ntr_n
mpirun --oversubscribe -np $nproc $AMBERHOME/bin/pmemd.MPI -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -inf $NEW.info

source ./submit_gpu_jobs.sh
