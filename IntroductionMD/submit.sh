#!/usr/bin/env bash

module load amber/amber22_ambertools23
module load cuda12.0/toolkit/12.0.1
module load openmpi/4.0.5

export CUDA_VISIBLE_DEVICES=0,1

$AMBERHOME/bin/pmemd -O -i min1.in -p complex.parm7 -c complex.rst7 -ref complex.rst7 -o min1.out -r min1.rst7 -inf min1.info
$AMBERHOME/bin/pmemd -O -i min2.in -p complex.parm7 -c min1.rst7 -ref min1.rst7 -o min2.out -r min2.rst7 -inf min2.info
$AMBERHOME/bin/pmemd.cuda -O -i heat-1.in -p complex.parm7 -c min2.rst7 -ref min2.rst7 -o heat-1.out -r heat-1.rst7 -x heat-1.nc -inf heat-1.info
$AMBERHOME/bin/pmemd.cuda -O -i press-1.in -p complex.parm7 -c heat-1.rst7 -ref heat-1.rst7 -o press-1.out -r press-1.rst7 -x press-1.nc -inf press-1.info
$AMBERHOME/bin/pmemd.cuda -O -i heat-2.in -p complex.parm7 -c press-1.rst7 -ref press-1.rst7 -o heat-2.out -r heat-2.rst7 -x heat-2.nc -inf heat-2.info
$AMBERHOME/bin/pmemd.cuda -O -i press-2.in -p complex.parm7 -c heat-2.rst7 -ref heat-2.rst7 -o press-2.out -r press-2.rst7 -x press-2.nc -inf press-2.info
$AMBERHOME/bin/pmemd.cuda -O -i heat-3.in -p complex.parm7 -c press-2.rst7 -ref press-2.rst7 -o heat-3.out -r heat-3.rst7 -x heat-3.nc -inf heat-3.info
$AMBERHOME/bin/pmemd.cuda -O -i press-3.in -p complex.parm7 -c heat-3.rst7 -ref heat-3.rst7 -o press-3.out -r press-3.rst7 -x press-3.nc -inf press-3.info
$AMBERHOME/bin/pmemd.cuda -O -i prod.in -p complex.parm7 -c press-3.rst7 -ref press-3.rst7 -o prod.out -r prod.rst7 -x prod.nc -inf prod.info
