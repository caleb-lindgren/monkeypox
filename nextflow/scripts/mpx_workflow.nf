#!/usr/bin/env nextflow

params.input = 'input.txt'

workflow {
    fasta_output = process run_nextflow(params.input)
}

process run_nextflow {
    input:
    file(input_file) from params.input

    output:
    file 'output.fasta'

    script:
    """
    nextflow nextflow_script2.nf --input ${input_file} --output output.fasta
    """
}
