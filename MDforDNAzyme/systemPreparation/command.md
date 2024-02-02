## Preparing the PDB file
```bash
wget https://files.rcsb.org/download/1TRA.pdb
# also 1DNO.pdb or 1EVV.pdb et al. (optional)
# using pymol to construct one pdb containing hexahydrated Mg2+:
# select resname HOH within 3 of resid 80
# select resid 80
# save selected atoms into Mg_hexa.pdb
# change H01 and H02 to H1 and H2 in Mg_hexa.pdb using vim editor

wget https://files.rcsb.org/download/7PDU.pdb
# only keep NMR structures MODEL 1 using vim editor, saved into 7pdu_cut.pdb
mkdir -p DNAzyme
cd DNAzyme
$AMBERHOME/bin/packmol-memgen --solvate --cubic --pdb ../7pdu_cut.pdb --output 7pdu_cut_packmol.pdb --salt --salt_c K+ --salt_a Cl- --saltcon 0.15 --salt_override --dist 30 --solute ../Mg_hexa.pdb --solute_con 0.2M --solute_charge +2
$AMBERHOME/bin/pdb4amber -i 7pdu_cut_packmol.pdb -o 7pdu_cut_packmol_p4a.pdb
cd ..
```

## Using tleap to generate the topology and coordinate files for next simulations
```bash
mkdir -p tleap
cd tleap
tleap -s -f tleap_DNAzyme.in
grep "Box dimensions" leap.log
# Box dimensions:  124.243000 124.446000 124.419000 => 1923709.8899
source /data/users/lipengfei/software/miniconda/2022.02/bin/activate base
python calculate_ion_conc.py --box_volume 1923709.8899 --ion_conc 150
tleap -s -f tleap_DNAzyme_ionconc.in
cd ..
```
