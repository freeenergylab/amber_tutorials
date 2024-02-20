#!/usr/bin/env bash
#SBATCH --job-name="prod"
#SBATCH --output="slurm.out"
#SBATCH --error="slurm.err"
#SBATCH --partition=4080
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --time=720:00:00
#SBATCH --gres=gpu:1

module load amber/amber22_ambertools23
module load cuda12.0/toolkit/12.0.1
module load openmpi/4.0.5

echo INFO: WORKDIR $PWD
echo INFO: HOSTNAME `hostname`
echo INFO: AMBERHOME $AMBERHOME

#nproc=32
#export CUDA_VISIBLE_DEVICES=0

#mpirun --oversubscribe -np $nproc $AMBERHOME/bin/pmemd.MPI -O -i min1.in -p complex.parm7 -c complex.rst7 -ref complex.rst7 -o min1.out -r min1.rst7 -inf min1.info
#mpirun --oversubscribe -np $nproc $AMBERHOME/bin/pmemd.MPI -O -i min2.in -p complex.parm7 -c min1.rst7 -ref min1.rst7 -o min2.out -r min2.rst7 -inf min2.info
#$AMBERHOME/bin/pmemd.cuda -O -i heat-1.in -p complex.parm7 -c min2.rst7 -ref min2.rst7 -o heat-1.out -r heat-1.rst7 -x heat-1.nc -inf heat-1.info
#mpirun --oversubscribe -np $nproc $AMBERHOME/bin/pmemd.MPI -O -i press-1.in -p complex.parm7 -c heat-1.rst7 -ref heat-1.rst7 -o press-1.out -r press-1.rst7 -x press-1.nc -inf press-1.info
#$AMBERHOME/bin/pmemd.cuda -O -i heat-2.in -p complex.parm7 -c press-1.rst7 -ref press-1.rst7 -o heat-2.out -r heat-2.rst7 -x heat-2.nc -inf heat-2.info
#$AMBERHOME/bin/pmemd.cuda -O -i press-2.in -p complex.parm7 -c heat-2.rst7 -ref heat-2.rst7 -o press-2.out -r press-2.rst7 -x press-2.nc -inf press-2.info
#$AMBERHOME/bin/pmemd.cuda -O -i heat-3.in -p complex.parm7 -c press-2.rst7 -ref press-2.rst7 -o heat-3.out -r heat-3.rst7 -x heat-3.nc -inf heat-3.info
#$AMBERHOME/bin/pmemd.cuda -O -i press-3.in -p complex.parm7 -c heat-3.rst7 -ref heat-3.rst7 -o press-3.out -r press-3.rst7 -x press-3.nc -inf press-3.info

$AMBERHOME/bin/pmemd.cuda -O -i relax.in -p complex.parm7 -c press-3.rst7 -ref press-3.rst7 -o relax.out -r relax.rst7 -x relax.nc -inf relax.info
$AMBERHOME/bin/pmemd.cuda -O -i prod.in -p complex.parm7 -c relax.rst7 -ref relax.rst7 -o prod-1.out -r prod-1.rst7 -x prod-1.nc -inf prod-1.info
for i in $(seq 2 1 10)
do
  echo "Running number $i prod simulation restarting $[i-1] simulation..."
  $AMBERHOME/bin/pmemd.cuda -O -i prod.in -p complex.parm7 -c prod-$[i-1].rst7 -ref prod-$[i-1].rst7 -o prod-$i.out -r prod-$i.rst7 -x prod-$i.nc -inf prod-$i.info
done
