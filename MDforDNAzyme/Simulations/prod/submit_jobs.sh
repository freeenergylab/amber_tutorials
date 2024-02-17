#!/usr/bin/env bash

module load amber/amber22_ambertools23
module load cuda12.0/toolkit/12.0.1
module load openmpi/4.0.5

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

export CUDA_VISIBLE_DEVICES=0

PRMTOP=../../systemPreparation/tleap/complex.parm7
RESOLD=../equil/md_nvt_red_06.rst7
BASE=md_nvt_prod

$AMBERHOME/bin/pmemd.cuda -O -i $BASE.in -p $PRMTOP -c $RESOLD -o $BASE-1.out -r $BASE-1.rst7 -x $BASE-1.nc -inf $BASE-1.info

for i in $(seq 2 1 10)
do
  echo "Running number $i $BASE simulation restarting $[i-1] simulation..."
  $AMBERHOME/bin/pmemd.cuda -O -i $BASE.in -p $PRMTOP -c $BASE-$[i-1].rst7 -o $BASE-$i.out -r $BASE-$i.rst7 -x $BASE-$i.nc -inf $BASE-$i.info
done
