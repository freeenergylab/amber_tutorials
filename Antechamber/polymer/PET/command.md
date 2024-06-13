## Generate a mononer structure
```bash
# draw this molecule using GV, then optimize it at B3LYP/6-31G(d) level
# here, we download from amber tutorial
wget https://ambermd.org/tutorials/advanced/tutorial27/files/mol_1_1.mol2
mv mol_1_1.mol2 pet_monomer.mol2
```

## Perform Gaussian calculations and do the RESP fitting
```bash
module load amber/amber24_ambertools24
module load gaussian/g16
antechamber -fi mol2 -fo gcrt -i pet_monomer.mol2 -o pet.gjf -pf y
# modify the pet.gjf file:
# --Link1--
#%nproc=32
#%mem=4gb
#%chk=pet.chk
##HF/6-31G* SCF=Tight Pop=MK IOp(6/33=2,6/41=10,6/42=17)

g16 < pet.gjf > pet.log
rm Gau-*
antechamber -fi gout -fo ac -i pet.log -o pet.ac -c resp -pf y
```

## Build the prepi files for the normal, N-terminal, and C-terminal PET monomers
```bash
wget https://ambermd.org/tutorials/advanced/tutorial27/files/mainchain.pet
mv mainchain.pet pet.mc
prepgen -i pet.ac -o pet.prepi -f prepi -m pet.mc -rn PET -rf pet.res

wget https://ambermd.org/tutorials/advanced/tutorial27/files/mainchain.hpt
mv mainchain.hpt hpt.mc
prepgen -i pet.ac -o hpt.prepi -f prepi -m hpt.mc -rn HPT -rf hpt.res

wget https://ambermd.org/tutorials/advanced/tutorial27/files/mainchain.tpt
mv mainchain.tpt tpt.mc
prepgen -i pet.ac -o tpt.prepi -f prepi -m tpt.mc -rn TPT -rf tpt.res
```

## Generate a polymer system
```bash
wget https://ambermd.org/tutorials/advanced/tutorial27/files/pet20_tleap.in
mv pet20_tleap.in tleap.in
tleap -s -f tleap.in
```
