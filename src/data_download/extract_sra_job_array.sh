#!/bin/bash

#SBATCH --time=01:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=8G   # memory per CPU core
#SBATCH --mail-user=calebmlindgren@gmail.com   # email address
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --output=output/slurm_%a.out 
#SBATCH --array=0-2

INPUT_DIR=~/fsl_groups/grp_bio465_mpxv/compute/compressed_sra_data
OUTPUT_DIR=~/fsl_groups/grp_bio465_mpxv/compute/extracted_sra_data

ACC=$(ls $INPUT_DIR | tr " " "\n" | head -$(($SLURM_ARRAY_TASK_ID + 1)) | tail -1)
mkdir $OUTPUT_DIR/$ACC

fasterq-dump $INPUT_DIR/$ACC -O $OUTPUT_DIR/$ACC
