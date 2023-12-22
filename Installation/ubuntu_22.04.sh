sudo apt -y update
sudo apt -y install tcsh make cmake gcc gfortran flex bison patch bc wget xorg-dev libbz2-dev
sudo apt -y install openmpi-bin libopenmpi-dev openssh-client

cd amber22_src/build
# optional: edit the run_cmake script to make any needed changes;
./run_cmake
# Next, build and install the code:
make -j8 install
