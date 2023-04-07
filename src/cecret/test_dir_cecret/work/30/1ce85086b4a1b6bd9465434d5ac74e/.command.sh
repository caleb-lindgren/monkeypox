#!/bin/bash -ue
mkdir -p fastqc logs/qc:fastqc
log=logs/qc:fastqc/SRR23322653.fd8870a5-bd9d-4e15-8ea8-b442ee313a53.log

# time stamp + capturing tool versions
date > $log
fastqc --version >> $log

fastqc        --outdir fastqc       --threads 1       SRR23322653.fastq       | tee -a $log

zipped_fastq=($(ls fastqc/*fastqc.zip) "")

raw_1=$(unzip -p ${zipped_fastq[0]} */fastqc_data.txt | grep "Total Sequences" | awk '{ print $3 }' )
raw_2=NA
if [ -f "${zipped_fastq[1]}" ] ; then raw_2=$(unzip -p fastqc/*fastqc.zip */fastqc_data.txt | grep "Total Sequences" | awk '{ print $3 }' ) ; fi

if [ -z "$raw_1" ] ; then raw_1="0" ; fi
if [ -z "$raw_2" ] ; then raw_2="0" ; fi

# capture process environment
set +u
echo raw_1=${raw_1[@]} > .command.env
echo raw_2=${raw_2[@]} >> .command.env
