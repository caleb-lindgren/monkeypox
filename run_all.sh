#!/bin/bash

#Run CECRET
sbatch STEP_1_assemble_genomes.sh

#Wait For Slurm
INPUT_DIR=~/fsl_groups/grp_bio465_mpxv/compute/extracted_sra_data/
SLURM_OUTPUT_DIR=./output

NUM_INPUT=$(ls $INPUT_DIR | tr " " "\n" | wc -l)

while [ $(ls $SLURM_OUTPUT_DIR | tr " " "\n" | wc -l) != $NUM_INTPUT ]
do
        sleep 1
done

#Generate Plots
python cecret/plots/coverage_vs_depth/make_coverage_vs_depth_plot.py ~/fsl_groups/grp_bio465_mpxv/compute/cecret_output/cecret_run_02/

#Run Nextclade
sbatch STEP_2_analyze_genome_lineages.sh
