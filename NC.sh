#!/bin/bash

#SBATCH --time=02:00:00   # walltime 
#SBATCH --ntasks=8   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=1024M   # memory per CPU core
#SBATCH -J "nc_%a"  # job name 
#SBATCH --output=ZACH_OUTPUT/wrapper_%a.out

NEXTCLADE_DIR=~/fsl_groups/grp_bio465_mpxv/compute/cecret_output/nextclade_fastas
OUTPUT_DIR=~/fsl_groups/grp_bio465_mpxv/compute/cecret_output/nextclade_output

rm -rf $OUTPUT_DIR
mkdir -p $OUTPUT_DIR

cd cecret_working_directory

RUST_BACKTRACE=1

./nextclade run \
   --input-dataset data/mpxv \
   --output-all=$OUTPUT_DIR/ \
   $NEXTCLADE_DIR/*.fa

echo "finished :)"
