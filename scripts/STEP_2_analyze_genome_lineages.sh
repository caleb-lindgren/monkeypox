#!/bin/bash

#SBATCH --time=02:00:00   # walltime 
#SBATCH --ntasks=8   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=1024M   # memory per CPU core
#SBATCH -J "nc_%a"  # job name 
#SBATCH --output=slurm_output/STEP_2

NEXTCLADE_DIR=cecret_output/nextclade_fastas/
OUTPUT_DIR=cecret_output/nextclade_output/

mkdir -p $OUTPUT_DIR

cd ../cecret_working_directory/

RUST_BACKTRACE=1

./nextclade run \
   --input-dataset data/mpxv \
   --output-all=../scripts/$OUTPUT_DIR/ \
   $NEXTCLADE_DIR/*.fa

echo "finished :)"
