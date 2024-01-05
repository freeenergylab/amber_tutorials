## Preparing the PDB file
```bash
wget https://files.rcsb.org/download/1EMA.pdb
pdb4amber -i 1EMA.pdb -o gfp.pdb --dry --reduce
sed -i -e '/CRYST1/d' gfp.pdb 
sed -i -e '/REMARK/d' gfp.pdb 
sed -i -e 's/HETATM/ATOM  /g' gfp.pdb
sed -i -e 's/MSE/MET/g' gfp.pdb
sed -i -e 's/SE   MET/ SD  MET/g' gfp.pdb
sed -i -e 's/SE / S /g' gfp.pdb
```
## Computing partial charges and atom types for CRO
```bash
wget https://ambermd.org/tutorials/basic/tutorial5/files/CRO.cif
antechamber -fi ccif -i CRO.cif -bk CRO -fo ac -o cro.ac -c bcc -at amber
sed -i -e 's/NT/N/g' cro.ac  # fix a mistake in AMBER atom type for antechamber
prepgen -i cro.ac -o cro.prepin -m cro.mc -rn CRO
parmchk2 -i cro.prepin -f prepi -o cro.frcmod -a Y -p $AMBERHOME/dat/leap/parm/parm10.dat
grep -v "ATTN" cro.frcmod > cro_1.frcmod
parmchk2 -i cro.prepin -f prepi -o cro_2.frcmod -a Y -p $AMBERHOME/dat/leap/parm/gaff2.dat
```

## Creating the topology and coordinate files
```bash
tleap -s -f tleap.in
```
