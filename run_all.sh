#!/bin/bash

# Directory setup
STEP_1_SLURM_OUTPUT_DIR=scripts/slurm_output/STEP_1
STEP_2_SLURM_OUTPUT_DIR=scripts/slurm_output/STEP_2

mkdir -p $STEP_1_SLURM_OUTPUT_DIR
mkdir -p $STEP_2_SLURM_OUTPUT_DIR

# Update step 1 job script to start correct number of array jobs

INPUT_DIR=extracted_sra_data/
NUM_INPUT=$(ls $INPUT_DIR | tr ' ' '\n' | wc -l)

sed -i "s/#SBATCH --array=/#SBATCH --array=0-$(($NUM_INPUT-1))/" scripts/STEP_1_assemble_genomes.sh

# Run CECRET
sbatch scripts/STEP_1_assemble_genomes.sh

# Wait For Slurm

while [ "$(ls $STEP_1_SLURM_OUTPUT_DIR | tr ' ' '\n' | wc -l)" != "$NUM_INPUT" ]
do
        sleep 1
done

#Generate Plots
python scripts/make_coverage_vs_depth_plot.py cecret_output/

#Run Nextclade
sbatch scripts/STEP_2_analyze_genome_lineages.sh
