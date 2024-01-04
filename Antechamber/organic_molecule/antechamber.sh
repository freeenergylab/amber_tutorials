#!/usr/bin/env bash

$AMBERHOME/bin/antechamber -i ejm_31.sdf -fi sdf -o vacuum.mol2 -fo mol2 -at gaff2 -c bcc -an n -nc 0 -rn MOL -dr no -pf y > /dev/null 2>&1
$AMBERHOME/bin/parmchk2 -i vacuum.mol2 -f mol2 -o vacuum.frcmod -a Y -p $AMBERHOME/dat/leap/parm/gaff2.dat
