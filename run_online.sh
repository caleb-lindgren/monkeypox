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

CONFIG="cecret_working_directory/cecret.config"
sed -i "40s|TO_REPLACE|reads|" "$CONFIG" # Paired reads
sed -i "41s|TO_REPLACE|single_reads|" "$CONFIG" # Single reads
sed -i "43s|TO_REPLACE|cecret|" "$CONFIG" # Output
sed -i "46s|8|1|" "$CONFIG"
sed -i "47s|8|1|" "$CONFIG"

mkdir cecret_output
mkdir cecret_output/consensus_fastas_for_nextclade
mkdir plots_output

echo "Extracting Nextflow dependencies..."
tar xf "9gnl5qnbzxvtj31eoxkkbi0i2ulswe1f.xz"
mv .nextflow "$HOME"
