nextflow.enable.dsl=2

process runScript {
    container 'staphb_toolkit:latest'

    output:
    stdout

    script:
    """
    staphb-tk
    """
}

workflow {
    runScript | view {it.trim()}
}
