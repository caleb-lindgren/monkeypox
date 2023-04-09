#!/bin/bash

module load miniconda3
conda create --name mpxv python=3.8 pip -y
conda activate mpxv
pip install matplotlib
pip install pandas
pip install seaborn

# Directory setup
STEP_1_SLURM_OUTPUT_DIR=scripts/slurm_output/consensus_fastas_for_nextclade
STEP_2_SLURM_OUTPUT_DIR=scripts/slurm_output/STEP_2

STEP_1_LOGS=scripts/slurm_output/STEP_1_LOGS
STEP_2_LOGS=scripts/slurm_output/STEP_2_LOGS

rm -rf $STEP_1_SLURM_OUTPUT_DIR
rm -rf $STEP_2_SLURM_OUTPUT_DIR

mkdir -p $STEP_1_SLURM_OUTPUT_DIR
mkdir -p $STEP_2_SLURM_OUTPUT_DIR
mkdir -p $STEP_1_LOGS
mkdir -p $STEP_2_LOGS

# Update step 1 job script to start correct number of array jobs

INPUT_DIR=extracted_sra_data/
NUM_INPUT=$(ls $INPUT_DIR | tr ' ' '\n' | wc -l)

sed -i "s/#SBATCH --array=.*/#SBATCH --array=0-$(($NUM_INPUT-1))/" scripts/STEP_1_assemble_genomes.sh
#sed -i "s/#SBATCH --array=/#SBATCH --array=0-$(($NUM_INPUT-1))/" scripts/STEP_1_assemble_genomes.sh

# Run CECRET
sbatch scripts/STEP_1_assemble_genomes.sh

# Wait For Slurm

while [ "$(ls $STEP_1_SLURM_OUTPUT_DIR | tr ' ' '\n' | wc -l)" != "$NUM_INPUT" ]
do
        # echo "$(ls $STEP_1_SLURM_OUTPUT_DIR | tr ' ' '\n' | wc -l)"
        sleep 1
done

#Generate Plots
python scripts/make_coverage_vs_depth_plot.py scripts/slurm_output/STEP_1

#Run Nextclade
sbatch scripts/STEP_2_analyze_genome_lineages.sh

echo 'started NextClade job'
