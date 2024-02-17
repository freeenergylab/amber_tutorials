#!/usr/bin/env bash

module load amber/amber22_ambertools23
module load cuda12.0/toolkit/12.0.1
module load openmpi/4.0.5

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

PRMTOP=../../systemPreparation/tleap/complex.parm7

export CUDA_VISIBLE_DEVICES=1

NEW=min_ntr_n
OLD=$NEW.rst7
NEW=md_nvt_ntr
$AMBERHOME/bin/pmemd.cuda -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -x $NEW.nc -inf $NEW.info

OLD=$NEW.rst7
NEW=md_npt_ntr_01
$AMBERHOME/bin/pmemd.cuda -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -x $NEW.nc -inf $NEW.info

OLD=$NEW.rst7
NEW=md_npt_ntr_02
$AMBERHOME/bin/pmemd.cuda -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -x $NEW.nc -inf $NEW.info

OLD=$NEW.rst7
NEW=md_nvt_red_01
$AMBERHOME/bin/pmemd.cuda -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -x $NEW.nc -inf $NEW.info

OLD=$NEW.rst7
NEW=md_nvt_red_02
$AMBERHOME/bin/pmemd.cuda -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -x $NEW.nc -inf $NEW.info

OLD=$NEW.rst7
NEW=md_nvt_red_03
$AMBERHOME/bin/pmemd.cuda -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -x $NEW.nc -inf $NEW.info

OLD=$NEW.rst7
NEW=md_nvt_red_04
$AMBERHOME/bin/pmemd.cuda -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -x $NEW.nc -inf $NEW.info

OLD=$NEW.rst7
NEW=md_nvt_red_05
$AMBERHOME/bin/pmemd.cuda -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -x $NEW.nc -inf $NEW.info

OLD=$NEW.rst7
NEW=md_nvt_red_06
$AMBERHOME/bin/pmemd.cuda -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -x $NEW.nc -inf $NEW.info
