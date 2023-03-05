#!/bin/bash

#SBATCH --time=00:10:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=2000M   # memory per CPU core
#SBATCH --mail-user=calebmlindgren@gmail.com   # email address
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --output=output/slrm_%a.out 
#SBATCH --array=0-742

ACC=$(ls $1 | tr " " "\n" | head -$(($SLURM_ARRAY_TASK_ID + 1)) | tail -1)
mkdir $2/$ACC
fasterq-dump $1/$ACC -O $2/$ACC
