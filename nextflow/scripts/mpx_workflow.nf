#!/usr/bin/env nextflow

params.input = 'input.txt'

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

workflow {
    fasta_output = run_cecret(params.input)
}
