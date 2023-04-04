#!/bin/bash

#SBATCH --time=01:00:00   # walltime 
#SBATCH --ntasks=8   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=1024M   # memory per CPU core
#SBATCH -J "cecret_%a"  # job name 
#SBATCH --output=ZACH_OUTPUT/slurm_%a.out
#SBATCH --array=0-5

# Load modules

module load singularity
module load jdk/1.12

mkdir -p /tmp/singularity/mnt/session

# Data directories setup
ALL_INPUT_DIR=~/fsl_groups/grp_bio465_mpxv/compute/extracted_sra_data/
ACC=$(ls $ALL_INPUT_DIR | tr " " "\n" | head -$(($SLURM_ARRAY_TASK_ID + 1)) | tail -1)
PREFIX="cecret_run_03"

INPUT_DIR=$ALL_INPUT_DIR/$ACC

ALL_OUTPUT_DIR=~/fsl_groups/grp_bio465_mpxv/compute/cecret_output
OUTPUT_DIR=$ALL_OUTPUT_DIR/$PREFIX/$ACC
NEXTCLADE_DIR=$ALL_OUTPUT_DIR/nextclade_fastas

rm -rf $NEXTCLADE_DIR
mkdir -p $NEXTCLADE_DIR

CECRET_DIR=/tmp/d/$ACC
rm -rf $CECRET_DIR
mkdir -p $CECRET_DIR

cp -r cecret_working_directory $CECRET_DIR
CECRET_DIR=$CECRET_DIR/cecret_working_directory

# Make a cecret.config file for this job
CONFIG=$CECRET_DIR/cecret_$ACC.config
cp $CECRET_DIR/cecret.config $CONFIG 

# Check if the directory is empty
if [ "$(ls -A $INPUT_DIR/paired)" ]; then
    PAIRED_FOUND=true
else
    PAIRED_FOUND=false
fi

# Print the result
echo "reads found in $INPUT_DIR/paired: $PAIRED_FOUND"

# Use the result for further processing
if [ $PAIRED_FOUND = true ]; then
    cp $INPUT_DIR/paired/* $CECRET_DIR/reads
else
    cp $INPUT_DIR/single/* $CECRET_DIR/single_reads
fi

cd $CECRET_DIR
export NXF_SINGULARITY_CACHEDIR=$CECRET_DIR/singularity_images

mkdir -p $OUTPUT_DIR

sed -i "40s|TO_REPLACE|reads|" $CONFIG # Paired reads 
sed -i "41s|TO_REPLACE|single_reads|" $CONFIG # Single reads 
sed -i "43s|TO_REPLACE|cecret|" $CONFIG # Output 

# This is how I got the nextclade dataset
# nextclade dataset get --name 'MPXV' --output-dir 'data/monkeypox'
# Next step (running auspice)
# https://docs.nextstrain.org/projects/auspice/en/stable/introduction/how-to-run.html

# Run cecret
./nextflow Cecret/main.nf \
   -c $CONFIG
 
echo "cp -r $CECRET_DIR $OUTPUT_DIR"

cp -r $CECRET_DIR/cecret/* $OUTPUT_DIR/
cp -r $CECRET_DIR/cecret/consensus/*consensus.fa $NEXTCLADE_DIR/

echo "output completed :)"
