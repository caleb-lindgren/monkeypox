#!/bin/bash

for study in $1/*; do
    if [[ -d $study ]]; then
        mkdir $study/single
        mkdir $study/paired
        for file in $study/*; do
            filename=$(basename -- $file)
            if [[ $filename =~ ^[A-Z0-9]_[12]\.fastq ]]; then
                mv $file $study/paired
            elif [[ $filename =~ ^[A-Z0-9]\.fastq ]]; then
                mv $file $study/single
            fi
        done
    fi
done
