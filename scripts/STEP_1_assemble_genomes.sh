#!/bin/bash

#SBATCH --time=01:00:00   # walltime 
#SBATCH --ntasks=8   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=1024M   # memory per CPU core
#SBATCH -J "cecret_%a"  # job name 
#SBATCH --output=slurm_output/STEP_1/slurm_%a.out
#SBATCH --array=0-149

# Load modules
module load singularity
module load jdk/1.12

# Necessary setup for Cecret
mkdir -p /tmp/singularity/mnt/session

# Data directories setup
CWD="$(pwd)"
ALL_INPUT_DIR="$CWD"/extracted_sra_data
ALL_OUTPUT_DIR="$CWD"/cecret_output

ACC="$(ls "$ALL_INPUT_DIR" | tr ' ' '\n' | head -$(($SLURM_ARRAY_TASK_ID + 1)) | tail -1)"
INPUT_DIR="$ALL_INPUT_DIR"/"$ACC"

OUTPUT_DIR="$ALL_OUTPUT_DIR"/"$ACC"
OUTPUT_FOR_NEXTCLADE_DIR="$ALL_OUTPUT_DIR"/consensus_fastas_for_nextclade

mkdir -p "$ALL_OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

CECRET_TMP_DIR=/tmp/d/"$ACC"
rm -rf "$CECRET_TMP_DIR"
mkdir -p "$CECRET_TMP_DIR"

cp -r cecret_working_directory "$CECRET_TMP_DIR"
CECRET_DIR="$CECRET_TMP_DIR"/cecret_working_directory

# Make a cecret.config file for this job
CONFIG="$CECRET_DIR"/cecret_"$ACC".config
cp "$CECRET_DIR"/cecret.config "$CONFIG" 

# Check if the directory is empty
if [ "$(ls -A "$INPUT_DIR"/paired)" ]; then
    PAIRED_FOUND=true
else
    PAIRED_FOUND=false
fi

# Print the result
echo "reads found in $INPUT_DIR/paired: $PAIRED_FOUND"

# Use the result for further processing
if [ $PAIRED_FOUND = true ]; then
    cp "$INPUT_DIR"/paired/* "$CECRET_DIR"/reads
else
    cp "$INPUT_DIR"/single/* "$CECRET_DIR"/single_reads
fi

echo $(pwd)
cd "$CECRET_DIR"
echo $(pwd)
echo $(ls)

export NXF_SINGULARITY_CACHEDIR="$CECRET_DIR"/singularity_images

sed -i "40s|TO_REPLACE|reads|" "$CONFIG" # Paired reads 
sed -i "41s|TO_REPLACE|single_reads|" "$CONFIG" # Single reads 
sed -i "43s|TO_REPLACE|cecret|" "$CONFIG" # Output 

# Run cecret
./nextflow Cecret/main.nf \
   -c "$CONFIG"

echo $(ls)

cd "$CWD"
cp -r "$CECRET_DIR"/cecret/* "$OUTPUT_DIR"
cp "$CECRET_DIR"/cecret/consensus/*consensus.fa "$OUTPUT_FOR_NEXTCLADE_DIR"

echo "output completed :)"
