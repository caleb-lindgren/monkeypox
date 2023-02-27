#!/bin/bash -ue
mkdir -p seqyclean logs/cecret:seqyclean
log=logs/cecret:seqyclean/SRR23322653.fd8870a5-bd9d-4e15-8ea8-b442ee313a53.log

# time stamp + capturing tool versions
date > $log
echo "seqyclean version: $(seqyclean -h | grep Version)" >> $log
cleaner_version="seqyclean : $(seqyclean -h | grep Version)"

seqyclean -minlen 25 -qual       -c /Adapters_plus_PhiX_174.fasta       -U SRR23322653.fastq       -o seqyclean/SRR23322653_cln       -gz       | tee -a $log

# capture process environment
set +u
echo cleaner_version=${cleaner_version[@]} > .command.env
