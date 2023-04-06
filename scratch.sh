INPUT_DIR=~/fsl_groups/grp_bio465_mpxv/compute/extracted_sra_data/
SLURM_OUTPUT_DIR=./output

NUM_INPUT=$(ls $INPUT_DIR | tr " " "\n" | wc -l)

while [ $(ls $SLURM_OUTPUT_DIR | tr " " "\n" | wc -l) != $NUM_INTPUT ]
do
	sleep 1
done
