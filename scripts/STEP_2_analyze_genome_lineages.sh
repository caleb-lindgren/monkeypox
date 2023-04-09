#!/bin/bash

#SBATCH --time=02:00:00   # walltime 
#SBATCH --ntasks=8   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=1024M   # memory per CPU core
#SBATCH -J "nextclade"  # job name 
#SBATCH --output=slurm_output/STEP_2/

CWD="$(pwd)"
CECRET_OUTPUT_FOR_NEXTCLADE_DIR="$CWD"/cecret_output/consensus_fastas_for_nextclade
MPXV_DATA_DIR="$CWD"/cecret_working_directory/data/monkeypox

OUTPUT_DIR="$CWD"/nextclade_output
mkdir -p "$OUTPUT_DIR"

RUST_BACKTRACE=1

cecret_working_directory/nextclade run \
   --input-dataset "$MPXV_DATA_DIR" \
   --output-all="$OUTPUT_DIR" \
   "$CECRET_OUTPUT_FOR_NEXTCLADE_DIR"/*.fa

echo "NEXTCLADE finished :)"
