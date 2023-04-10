#!/bin/bash

# Download and extract Cecret and example reads
echo "Downloading MPXV reads..."
wget https://byu.box.com/shared/static/vbyi1n05chlbah2fmcuts5nwegyxyzxb.xz
echo "Downloading Cecret..."
wget https://byu.box.com/shared/static/y5nke4x985rtt4li4t4xlue6lffndtq3.xz

echo "Extracting MPXV reads..."
tar xf vbyi1n05chlbah2fmcuts5nwegyxyzxb.xz
echo "Extracting Cecret..."
tar xf y5nke4x985rtt4li4t4xlue6lffndtq3.xz

# Install Nextclade for Linux
echo "Installing Nextclade..."
CWD="$(pwd)"
CECRET_WORKING_DIR="$CWD"/cecret_working_directory
NEXTCLADE_BINARY="$CECRET_WORKING_DIR"/nextclade
NEXTCLADE_MONKEYPOX_DATA="$CECRET_WORKING_DIR"/data/monkeypox

curl -fsSL "https://github.com/nextstrain/nextclade/releases/latest/download/nextclade-x86_64-unknown-linux-gnu" -o "$NEXTCLADE_BINARY" && chmod +x "$NEXTCLADE_BINARY"

# Download Nextclade global MPXV dataset
"$NEXTCLADE_BINARY" dataset get --name 'MPXV' --output-dir "$NEXTCLADE_MONKEYPOX_DATA"

# Download required Nextflow files
echo "Installing Nextflow dependencies..."
wget "https://byu.box.com/shared/static/9gnl5qnbzxvtj31eoxkkbi0i2ulswe1f.xz"

echo "Extracting Nextflow dependencies..."
tar xf "9gnl5qnbzxvtj31eoxkkbi0i2ulswe1f.xz"
mv .nextflow "$HOME"

# Set up Python environment
echo "Configuring Python environment..."
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

mkdir -p "$CECRET_OUTPUT_FOR_NEXTCLADE_DIR"
mkdir -p "$STEP_1_SLURM_OUTPUT_DIR"
mkdir -p "$STEP_2_SLURM_OUTPUT_DIR"

# Update step 1 job script to start correct number of array jobs

INPUT_DIR="$CWD"/extracted_sra_data
NUM_INPUT=$(ls "$INPUT_DIR" | tr ' ' '\n' | wc -l)

STEP_1_SCRIPT="$CWD/scripts/STEP_1_assemble_genomes.sh"

sed -i "s/#SBATCH --array=.*$/#SBATCH --array=0-$(($NUM_INPUT-1))/" "$STEP_1_SCRIPT"

# Run CECRET
echo "Running Cecret..."
sbatch "$STEP_1_SCRIPT"

# Wait For Slurm

while [ "$(ls "$CECRET_OUTPUT_FOR_NEXTCLADE_DIR" | tr ' ' '\n' | wc -l)" != "$NUM_INPUT" ]
do
    count=$(ls -1 "$CECRET_OUTPUT_FOR_NEXTCLADE_DIR" | wc -l)
    progress=$(awk "BEGIN {printf \"%.0f\n\",($count/"$NUM_INPUT")*100}")
    bar=$(seq -s "#" $progress | sed 's/[0-9]//g')
    echo -ne "[$bar] ($count/$NUM_INPUT)\r"
    sleep 10
done

# Generate Plots
echo "Generating coverage vs. depth plot..."
python "$CWD"/scripts/make_coverage_vs_depth_plot.py cecret_output

# Run Nextclade
echo "Running Nextclade..."
sbatch "$CWD"/scripts/STEP_2_analyze_genome_lineages.sh
echo "Use squeue -u to check for Nextclade job completetion."
