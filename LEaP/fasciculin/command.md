Copyright (C) 2023-2024 freeenergylab
## Preprocess
```bash
  wget https://files.rcsb.org/download/1FSC.pdb
  pdb4amber -i 1FSC.pdb -o 1fsc_amber.pdb --dry
  sed -i -e '/CRYST1/d' 1fsc_amber.pdb 
  sed -i -e '/REMARK/d' 1fsc_amber.pdb 
  sed -i -e '/UNL/d' 1fsc_amber.pdb 
  sed -i -e '/CONECT/d' 1fsc_amber.pdb 
```
## LEaP: tleap
```bash
  tleap -s -f tleap.in
```
