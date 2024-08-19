```bash
lipengfei@headnode ~/software/drroe/AmberMdPrep (master?) $ module load amber/amber24_ambertools24
lipengfei@headnode ~/software/drroe/AmberMdPrep (master?) $ module load cuda12.0/toolkit/12.0.1   
lipengfei@headnode ~/software/drroe/AmberMdPrep (master?) $ ./AmberMdPrep.sh -p ./test/tz2.ortho.parm7 -c ./test/tz2.ortho.rst7 --temp 300
AmberMdPrep.sh Version 0.5 (beta)
  TOP            : ./test/tz2.ortho.parm7
  CRD            : ./test/tz2.ortho.rst7
  13 protein, 0 dna, 0 rna, 0 lipid, 0 carbohydrate, 1691 water, 0 other
  Detected types :  protein
  NUM SOLUTE RES : 13
  HEAVY MASK     : :1-13&!@H=
  BACKBONE MASK  : :1-13@H,N,CA,HA,C,O
  TEMPERATURE    : 300
  OVERWRITE      : 0
  MD COMMAND     : pmemd.cuda
  MIN COMMAND    : pmemd.cuda_DPFP
  NPROCS         : 4

Performing standard min/equil
Minimization: step1
MD: step2
Minimization: step3
Minimization: step4
Minimization: step5
MD: step6
MD: step7
MD: step8
MD: step9
Starting final density equilibration.
Using CPPTRAJ to evaluate density plateau.
Final 1
MD: final.1
Info: Redirecting output to file 'Eval.out'
Complete.
Equilibration success
```