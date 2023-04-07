params.str = 'Hello world!'
params.cecret_url = "https://github.com/UPHL-BioNGS/Cecret/main.nf"

process run_cecret {
  output:
    stdout
  script:
    """
    echo $params.cecret_url
    nextflow run $params.cecret_url | tee cecret_output.txt
    """
}

process Cecret {
  """
  nextflow run Cecret/main.nf -c cecret.config 
  """
}

process test {

    output:
    stdout

    shell:
    '''
    echo pwd
    '''
}

workflow {
   run_cecret | view {it.trim()}
}
