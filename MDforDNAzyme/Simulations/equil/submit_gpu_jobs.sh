#!/usr/bin/env bash

module load amber/amber22_ambertools23
module load cuda12.0/toolkit/12.0.1
module load openmpi/4.0.5

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

EXE=$AMBERHOME/bin/pmemd.cuda
PRMTOP=../../systemPreparation/tleap/complex.parm7

export CUDA_VISIBLE_DEVICES=1

NEW=min_ntr_n
OLD=$NEW.rst7
NEW=md_nvt_ntr
$EXE -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -x $NEW.nc

OLD=$NEW.rst7
NEW=md_npt_ntr_01
$EXE -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -x $NEW.nc

OLD=$NEW.rst7
NEW=md_npt_ntr_02
$EXE -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -x $NEW.nc

OLD=$NEW.rst7
NEW=md_nvt_red_01
$EXE -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -x $NEW.nc

OLD=$NEW.rst7
NEW=md_nvt_red_02
$EXE -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -x $NEW.nc

OLD=$NEW.rst7
NEW=md_nvt_red_03
$EXE -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -x $NEW.nc

OLD=$NEW.rst7
NEW=md_nvt_red_04
$EXE -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -x $NEW.nc

OLD=$NEW.rst7
NEW=md_nvt_red_05
$EXE -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -x $NEW.nc

OLD=$NEW.rst7
NEW=md_nvt_red_06
$EXE -O -i ${NEW}.in -o $NEW.out -p $PRMTOP -c $OLD -r $NEW.rst7 -ref $OLD -x $NEW.nc
