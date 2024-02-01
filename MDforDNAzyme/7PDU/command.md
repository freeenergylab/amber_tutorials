## Preparing the PDB file
```bash
wget https://files.rcsb.org/download/1TRA.pdb
# using pymol to construct one pdb containing hexahydrated Mg2+:
# select resname HOH within 3 of resid 80
# select resid 80
# save selected into Mg_hexa.pdb

wget https://files.rcsb.org/download/7PDU.pdb
mkdir -p systemPreparation
cd systemPreparation
# only keep NMR structures MODEL 1 using vim editor, saved into 7pdu_cut.pdb
$AMBERHOME/bin/packmol-memgen --solvate --cubic --pdb ../7pdu_cut.pdb --output 7pdu_cut_packmol.pdb --salt --salt_c Na+ --salt_a Cl- --saltcon 0.15 --dist 15 --solute ../Mg_hexa.pdb --solute_con 0.02M --solute_charge +2
$AMBERHOME/bin/pdb4amber -i 7pdu_cut_packmol.pdb -o 7pdu_cut_packmol_p4a.pdb

sed -i -e '/CRYST1/d' 1PY2_amber.pdb 
sed -i -e '/REMARK/d' 1PY2_amber.pdb 
sed -i -e 's/HETATM/ATOM  /g' 1PY2_amber.pdb
sed -i -e '/CONECT/d' 1PY2_amber.pdb
```

