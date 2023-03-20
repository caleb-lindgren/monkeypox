#!/usr/bin/env nextflow

params.input = 'input.txt'

workflow {
    fasta_output = process run_cecret(params.input)
}

process run_cecret {
    input:
    file(input_file) from params.input

    output:
    file 'output.fasta'

    script:
    """
    nextflow main.nf --input ${input_file} -c cecret.config
    """
}
