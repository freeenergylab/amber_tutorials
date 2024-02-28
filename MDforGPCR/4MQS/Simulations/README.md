This tutorial mainly refers to https://github.com/callumjd/AMBER-Membrane_protein_tutorial.

Here, the simulation steps are as follows:

* 01_Min.in    : 1000 steps of short minimization on CPU with pmemd. This is advised for membrane systems, which often have bad clashes of lipid chains to resolve. The CPU code is more robust in dealing with these than the GPU
* 02_Min.in    : 10000 steps of longer minimization on GPU
* 03_Heat.in   : heating to 100 K, with restraints on M2 receptor, iperoxo, membrane lipids
* 04_Heat.in   : heating to 300 K, with restraints on M2 receptor, iperoxo, membrane lipids
* 05_Back.in   : run 1 ns NPT with restraints on receptor backbone atoms, iperoxo
* 06_Calpha.in : run 1 ns NPT with restraints on receptor carbon-alpha atoms, iperoxo
* 07_Prod.in   : run 100 ns NPT equilibration, all restraints removed
* 08_Long.in   : run 500 ns NPT production, with Berendsen barostat and hydrogen mass repartitioning
