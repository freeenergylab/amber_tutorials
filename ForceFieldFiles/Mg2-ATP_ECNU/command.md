## Create a TOP file using the command "tleap -f tleap.in":
```bash
addatomtypes {{"O3""O""sp2"}}
addatomtypes {{"O2""O""sp2"}}
addatomtypes {{"O""O""sp2"}}
addatomtypes {{"OW""O""sp3"}}
addatomtypes {{"OY""O""sp3"}}
source leaprc.*                  # Load protein force fields you want
source leaprc.water.tip3p        # Load water models
loadAmberPrep ATP-HF/B3.prepi    # Load prepi file
loadAmberParams ATP-HF/B3.frcmod # Load frcmod file
......                           # Other operations
saveamberparm name *.prmtop *.inpcrd
quit
```

## Use "mod.py" to modify vdW parameters and add CMAP parameters:
```bash
# Please install parmed and numpy extral python packages
python mod.py -top *.prmtop -out *-out.prmtop -method B3LYP/HF
```
