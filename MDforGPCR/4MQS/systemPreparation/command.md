## Preparing the PDB file
```bash
wget https://files.rcsb.org/download/4MQS.pdb
# pdb4amber -i 4MQS.pdb -o 4mqs_amber.pdb --dry
grep "SSBOND" 4MQS.pdb
# grep "MISSING RESIDUES" 4MQS.pdb
wget https://opm-assets.storage.googleapis.com/pdb/4mqs.pdb
mv 4mqs.pdb 4mqs_opm.pdb
mkdir -p receptor
cd receptor
grep ' A ' ../4mqs_opm.pdb > M2_only.pdb
sed -i -e '/HETATM/d' M2_only.pdb
cd ..

mkdir -p ligand
cd ligand
grep 'IXO' ../4mqs_opm.pdb > IXO_ligand.pdb
# the hydrogen atoms of ligand IXO need to be modified by pymol/Builder
# the hydrogen atoms of ligand IXO were added by pymol => IXO_ligand_pymol.pdb
cd ..
```

## Preparing the force field parameters for ligand IXO
```bash
cd ligand
$AMBERHOME/bin/antechamber -i IXO_ligand_pymol.pdb -fi pdb -o IXO_ligand.mol2 -fo mol2 -at gaff2 -c bcc -an n -nc 1 -rn MOL -dr no -pf y
$AMBERHOME/bin/parmchk2 -i IXO_ligand.mol2 -f mol2 -o IXO_ligand.frcmod -a Y -p $AMBERHOME/dat/leap/parm/gaff2.dat
grep "ATTN, need revision" IXO_ligand.frcmod
tleap -s -f convert.leap

mkdir -p to_sdf_rdkit
cd to_sdf_rdkit
$AMBERHOME/bin/antechamber -i ../IXO_ligand_pymol.pdb -fi pdb -o IXO_ligand_sybyl.mol2 -fo mol2 -at sybyl -c bcc -an n -nc 1 -rn MOL -dr no -pf y
# activate conda env containing rdkit software module
source /data/users/lipengfei/software/miniconda/2022.02/bin/activate base
python mol2_to_sdf_rdkit.py
cd ../..
```

## Considering protonated states using H++ server
```bash
cd receptor
mkdir -p H++
cd H++
cp ../M2_only.pdb .
# edit this M2_only.pdb file to add TER between discontinuous residues, e.g. 215---377
# upload the edited pdb file on H++ website to calculate protonated states, then download .top and .crd files
# http://newbiophysics.cs.vt.edu/H++/index.php
# wget both .top and .crd files
ambpdb -p 0.15_80_10_pH7.4_M2_only.top -c 0.15_80_10_pH7.4_M2_only.crd > M2_only_H++.pdb
# ASP69 is protonated during the entire photocycle in rhodopsin (https://www.pnas.org/content/90/21/10206.long)
# thus, ASP69 inside the helical bundle, which is charge neutral ("ASH" residue name, as AMBER convention)
# notice that residue index are reindexed from 1 as start
sed -i -e 's/ASP    51/ASH    51/g' M2_only_H++.pdb
cd ../..
```

## Using tleap to generate the topology and coordinate files for protein-ligand in water box
```bash
mkdir -p tleap
cd tleap
# notice that the SSBOND residue index are reindexed
tleap -s -f tleap.in
cd ..
```

## Building the membrane
```bash
mkdir -p build_membrane
cd build_membrane
source ./packmol-memgen.sh
# since this IXO ligand has a +1 charge, we need to delete a single Na+ ion from the output PDB file
# you can use a text editor to simply remove the first Na+ or use sed command like:
sed -i -e '/Na+  Na+ G   1/d' bilayer_complex_solute.pdb
cd ..
```

## Using tleap to generate the topology and coordinate files for protein-ligand embedded in membrane
```bash
cd build_membrane
mkdir -p tleap
cd tleap
tleap -s -f build.leap
$AMBERHOME/bin/parmed -i hmass_parmed.in
cd ..
```
