Copyright (C) 2023-2024 freeenergylab
## Prerequisites
```bash
  sudo apt -y update
  sudo apt -y install tcsh make cmake gcc gfortran flex bison patch bc wget xorg-dev libbz2-dev
  sudo apt -y install openmpi-bin libopenmpi-dev openssh-client
```
partially if your environment has:
```bash
  module purge
  module load gcc9/9.3.0
  module load cuda12.0/toolkit/12.0.1
  module load openmpi/4.0.5
```

## Installation
- **Amber22 & AmberTools23**: Amber22 is licensed and AmberTools23 is free.
```bash
md5sum Amber22.tar.bz2
md5sum AmberTools23.tar.bz2
```
593ebf62e152f4add0f171b631c18bdc  Amber22.tar.bz2

073deadb3edfa96f86da91e3b070d2bc  AmberTools23.tar.bz2
```bash
  cd /Where/You/Want/To/Install/Directory
  tar xvf AmberTools23.tar.bz2
  tar xvf Amber22.tar.bz2
  cd amber22_src/build
  # optional: edit the run_cmake script to make any needed changes;
  vim run_cmake
  ./run_cmake
  make -j32 install
```
