#!/bin/bash

#SBATCH --time=00:10:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=1G   # memory per CPU core
#SBATCH --mail-user=calebmlindgren@gmail.com   # email address
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --output=output/slurm_%a.out 
#SBATCH --array=0-2

INPUT_DIR=../../../../fsl_groups/grp_bio465_mpxv/compute/small_in
OUTPUT_DIR=../../../../fsl_groups/grp_bio465_mpxv/compute/small_out

ACC=$(ls $INPUT_DIR | tr " " "\n" | head -$(($SLURM_ARRAY_TASK_ID + 1)) | tail -1)
mkdir $OUTPUT_DIR/$ACC

fasterq-dump $INPUT_DIR/$ACC -O $OUTPUT_DIR/$ACC
