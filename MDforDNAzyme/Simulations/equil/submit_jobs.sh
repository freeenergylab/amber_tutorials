#!/usr/bin/env bash

module load amber/amber22_ambertools23
module load cuda12.0/toolkit/12.0.1
module load openmpi/4.0.5

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

nproc=32
DO_PARALLEL=mpirun --oversubscribe -np $nproc
EXE=$AMBERHOME/bin/pmemd.MPI
PRMTOP=../../systemPreparation/tleap/complex.parm7
INPCRD=../../systemPreparation/tleap/complex.rst7

OLD=$INPCRD
NEW=min_ntr_h
$DO_PARALLEL $EXE -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD

OLD=$NEW.rst7
NEW=min_ntr_l
$DO_PARALLEL $EXE -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD

OLD=$NEW.rst7
NEW=min_ntr_n
$DO_PARALLEL $EXE -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD

source ./submit_gpu_jobs.sh
