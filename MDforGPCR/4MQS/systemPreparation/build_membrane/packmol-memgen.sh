#!/usr/bin/env bash

module load amber/amber22_ambertools23

$AMBERHOME/bin/packmol-memgen --pdb ../tleap/complex_solute.pdb --lipids POPC:CHL1 --ratio 9:1 --preoriented --salt --salt_c Na+ --saltcon 0.15 --dist 10 --dist_wat 15 --notprotonate --nottrim
