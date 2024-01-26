## Preparing the PDB file
```bash
wget https://files.rcsb.org/download/1PY2.pdb
mkdir -p receptor
cd receptor
pdb4amber -i ../1PY2.pdb -o 1PY2_amber.pdb --dry
sed -i -e '/CRYST1/d' 1PY2_amber.pdb 
sed -i -e '/REMARK/d' 1PY2_amber.pdb 
sed -i -e 's/HETATM/ATOM  /g' 1PY2_amber.pdb
sed -i -e '/CONECT/d' 1PY2_amber.pdb
pymol 1PY2_amber.pdb # visualize the protein structure
# header section: SEQRES in 1PY2.pdb => keep only chain A using vim
vim 1PY2_amber.pdb

cd ..
grep "FRH A" 1PY2.pdb | grep "HETATM" > ./ligand/FRH_A.pdb
# the hydrogen atoms of ligand FRH need to be modified by pymol (reduce did not work well here)
# the hydrogen atoms of ligand FRH were added by pymol => FRH_A_pymol.pdb
```

## Preparing the force field parameters for ligand FRH
```bash
mkdir -p ligand
cd ligand
$AMBERHOME/bin/antechamber -i FRH_A_pymol.pdb -fi pdb -o SP4206.mol2 -fo mol2 -at gaff2 -c bcc -an n -nc 0 -rn MOL -dr no -pf y
$AMBERHOME/bin/parmchk2 -i SP4206.mol2 -f mol2 -o SP4206.frcmod -a Y -p $AMBERHOME/dat/leap/parm/gaff2.dat
grep "ATTN, need revision" SP4206.frcmod

mkdir -p to_sdf_rdkit
cd to_sdf_rdkit
$AMBERHOME/bin/antechamber -i ../FRH_A_pymol.pdb -fi pdb -o SP4206_sybyl.mol2 -fo mol2 -at sybyl -c bcc -an n -nc 0 -rn MOL -dr no -pf y
# activate conda env containing rdkit software module
source /data/users/lipengfei/software/miniconda/2022.02/bin/activate base
python mol2_to_sdf_rdkit.py
cd ../..
```

## Adding missing residues
```bash
cd receptor
mkdir -p addMissingResidues
cd addMissingResidues
# activate conda env containing modeller software module
source /data/users/lipengfei/software/miniconda/2022.02/bin/activate base
cp ../1PY2_amber.pdb .
python getSeq.py
!cp 1PY2_amber.seq alignment.ali # modify this .ali file manually
python addMissingResidues.py
cd ..
```

## Considering protonated states using H++ server
```bash
mkdir -p H++
cd H++
cp ../addMissingResidues/1PY2_amber_fill.BL00010001.pdb .
# upload this pdb file on H++ website to calculate protonated states, then download .top and .crd files
# http://newbiophysics.cs.vt.edu/H++/index.php
# wget both .top and .crd files
ambpdb -p 0.15_80_10_pH7.0_1PY2_amber_fill.BL00010001.top -c 0.15_80_10_pH7.0_1PY2_amber_fill.BL00010001.crd > 1PY2_amber_fill_H++.pdb
cd ../../
```

## Using tleap to generate the topology and coordinate files for next simulations
```bash
mkdir -p tleap
cd tleap
tleap -s -f tleap.in
# get the box volume info to calculate the ion concentration
grep "Volume" leap.log
# or
cpptraj -i cpptraj.in
source /data/users/lipengfei/software/miniconda/2022.02/bin/activate base
python calculate_ion_conc.py --box_volume 345635.536 --ion_conc 150
# get the number of Cl- ions to replace the numbers in tleap_ionconc.in file
tleap -s -f tleap_ionconc.in
cd ..
```
