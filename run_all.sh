#!/bin/bash

# Download and extract Cecret and example reads
wget https://byu.box.com/shared/static/vbyi1n05chlbah2fmcuts5nwegyxyzxb.xz
wget https://byu.box.com/shared/static/y5nke4x985rtt4li4t4xlue6lffndtq3.xz

tar xf vbyi1n05chlbah2fmcuts5nwegyxyzxb.xz
tar xf y5nke4x985rtt4li4t4xlue6lffndtq3.xz

# Install Nextclade for Linux
CWD="$(pwd)"
NEXTCLADE_WORKING_DIR="$CWD"/nextclade_working_directory
NEXTCLADE_BINARY="$NEXTCLADE_WORKING_DIR"/nextclade
NEXTCLADE_MONKEYPOX_DATA="$NEXTCLADE_WORKING_DIR"/monkeypox

mkdir -p "$NEXTCLADE_WORKING_DIR"

curl -fsSL "https://github.com/nextstrain/nextclade/releases/latest/download/nextclade-x86_64-unknown-linux-gnu" -o "$NEXTCLADE_BINARY" && chmod +x "$NEXTCLADE_BINARY"

# Download Nextclade global MPXV dataset
"$NEXTCLADE_BINARY" dataset get --name 'MPXV' --output-dir "$NEXTCLADE_MONKEYPOX_DATA"

# Set up Python environment
module load miniconda3
conda create --name mpxv python=3.8 matplotlib pandas seaborn -y
conda activate mpxv

# Directory setup
CECRET_OUTPUT_FOR_NEXTCLADE_DIR="$CWD"/cecret_output/consensus_fastas_for_nextclade
STEP_1_SLURM_OUTPUT_DIR="$CWD"/slurm_output/STEP_1
STEP_2_SLURM_OUTPUT_DIR="$CWD"/slurm_output/STEP_2

rm -rf "$CECRET_OUTPUT_FOR_NEXTCLADE_DIR"
rm -rf "$STEP_1_SLURM_OUTPUT_DIR"
rm -rf "$STEP_2_SLURM_OUTPUT_DIR"

mkdir -p "$STEP_1_SLURM_OUTPUT_DIR"
mkdir -p "$STEP_2_SLURM_OUTPUT_DIR"

# Update step 1 job script to start correct number of array jobs

INPUT_DIR="$CWD"/extracted_sra_data
NUM_INPUT=$(ls "$INPUT_DIR" | tr ' ' '\n' | wc -l)

STEP_1_SCRIPT="$CWD/scripts/STEP_1_assemble_genomes.sh"

sed -i "s/#SBATCH --array=.*$/#SBATCH --array=0-$(($NUM_INPUT-1))/" "$STEP_1_SCRIPT"

# Run CECRET
sbatch "$STEP_1_SCRIPT"

# Wait For Slurm

while [ "$(ls "$CECRET_OUTPUT_FOR_NEXTCLADE_DIR" | tr ' ' '\n' | wc -l)" != "$NUM_INPUT" ]
do
        echo "$(ls "$CECRET_OUTPUT_FOR_NEXTCLADE_DIR" | tr ' ' '\n' | wc -l)"
        sleep 1
done

# Generate Plots
python "$CWD"/scripts/make_coverage_vs_depth_plot.py cecret_output

# Run Nextclade
sbatch "$CWD"/scripts/STEP_2_analyze_genome_lineages.sh

echo 'started NextClade job'
