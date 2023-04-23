samples = ["ERR10009304","SRR21205528"]

rule all:
    input:
        "nextclade_output/nextclade.auspice.json",
        "plots_output/figure_2.png",
        "plots_output/figure_3.png"

rule copy_cecret:
    input:
        "extracted_sra_data/{sample}/paired/"
    output:
        directory("/tmp/{sample}_cecret_working_directory")
    shell:
        """
        mkdir cecret_output/{wildcards.sample}
        cp -r cecret_working_directory /tmp/{wildcards.sample}_cecret_working_directory/
        cp -r {input}/* /tmp/{wildcards.sample}_cecret_working_directory/reads/
        """

rule process_data:
    input:
        directory("/tmp/{sample}_cecret_working_directory/")
    output:
        "cecret_output/consensus_fastas_for_nextclade/{sample}.consensus.fa"
    shell:
        """
        echo "GOT TO PROCESS STEP! copying/setup completed successfully"

        module load jdk/1.12
        module load singularity
        mkdir -p /tmp/singularity/mnt/session

	# setup this shell's cecret
        CWD=$(pwd)
        export NXF_SINGULARITY_CACHEDIR=/tmp/{wildcards.sample}_cecret_working_directory/singularity_images

	# enter cecret_working_directory
        cd /tmp/{wildcards.sample}_cecret_working_directory

	# run cecret
        ./nextflow Cecret/main.nf -c cecret.config

	# copy consensus file to outer final directory
        cp -r cecret/* $CWD/cecret_output/{wildcards.sample}
        cp cecret/consensus/{wildcards.sample}.consensus.fa $CWD/cecret_output/consensus_fastas_for_nextclade/{wildcards.sample}.consensus.fa
        """

rule run_nextclade:
    input:
        expand("cecret_output/consensus_fastas_for_nextclade/{sample}.consensus.fa", sample=samples)
    output:
        "nextclade_output/nextclade.auspice.json"
    shell:
        """
        CWD="$(pwd)"
        CECRET_OUTPUT_FOR_NEXTCLADE_DIR="$CWD"/cecret_output/consensus_fastas_for_nextclade
        MPXV_DATA_DIR="$CWD"/cecret_working_directory/data/monkeypox

        OUTPUT_DIR="$CWD"/nextclade_output
        mkdir -p "$OUTPUT_DIR"


        cecret_working_directory/nextclade run \
           --input-dataset "$MPXV_DATA_DIR" \
           --output-all="$OUTPUT_DIR" \
           "$CECRET_OUTPUT_FOR_NEXTCLADE_DIR"/*.fa

        echo "NEXTCLADE finished :)"
        """

rule generate_plots:
    input:
        "nextclade_output/nextclade.auspice.json"
    output:
        "plots_output/figure_2.png",
        "plots_output/figure_3.png"
    shell:
        """
        python scripts/make_figure_2.py
        python scripts/make_figure_3.py cecret_output

        mv figure_2.png plots_output
        mv figure_3.png plots_output
        """

