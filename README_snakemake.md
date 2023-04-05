# Emerging Viral Strains 
### SNAKEMAKE INSTRUCTIONS

## Project descriptions

(DC Public Health, Janis Doss - Janis.doss@dc.gov)

Whole genome sequencing (WGS) has become more prevalent in public health laboratories in recent years due to the COVID-19 pandemic. Many public health labs are now using their enhanced WGS infrastructure to sequence other emerging pathogens; however, bioinformatic methods must be adapted to the organism, resources available, and specific needs of the lab. The largest monkeypox (MPX) outbreak outside of non-endemic areas occurred in 2022 and many public health labs became interested in sequencing MPX for surveillance, outbreak investigations, and research. The MPX virus has some interesting genetic characteristics, such as a large 197 kb genome, the presence of tandem repeats, and a tendency to evolve by gene loss rather than progressive point mutations. Imagine you are the bioinformatician for a lab that is starting to sequence MPX samples. Develop a protocol for MPX bioinformatic analysis, including preprocessing of raw reads, genome assembly, quality assessment, lineage classification, and visualization of results (alignments and trees). You can use fastq files from the NCBI Sequence Read Archive (SRA). If possible, create an automated pipeline/workflow using Nextflow, Galaxy, or other software.
 
Resources that would be helpful for this project would include:
- [NCBI SRA](https://www.ncbi.nlm.nih.gov/sra) to download fastq files
- [Nextclade](https://clades.nextstrain.org/) can do monkeypox lineage classification, alignments, and trees
- [This](https://www.ncbi.nlm.nih.gov/nuccore/NC_063383) is a good reference genome for monkeypox
- There are many free assembly programs, such as [Cecret](https://github.com/UPHL-BioNGS/Cecret)

## System requirements

This workflow was developed on a high performance computing cluster with the following software:

- Red Hat Enterprise Linux Server 7.9
- Slurm 22.05.7
- wget 1.14
- Python 3
    - Matplotlib
    - Numpy
    - Pandas
    
Additionally, you will need internet access while you are logged in to the cluster, but computing jobs that you run on the cluster will not require internet access. 

## Instructions for use

1. Log in to your high performance computing cluster. 
2. Clone this GitHub repository ([https://github.com/caleb-lindgren/monkeypox](https://github.com/caleb-lindgren/monkeypox))
3. Use wget or a similar program to download the following files:
    - Data files:
    - Cecret: https://byu.box.com/s/dyp7hqvijtyot9ne0yl0sjmq3dbrd2kp
4. Unzip the downloaded files.
5. Follow the following instructions to install NextClade and the MPXV dataset:
    - [NextClade install instructions](https://docs.nextstrain.org/projects/nextclade/en/stable/user/nextclade-cli.html#download-from-command-line)
	- Move the `nextclade` directory into the unzipped `cecret_working_directory` using the following code.
	```unix
	mv -r nextclade /PATH/TO/cecret_working_directory
	```
	- Download the NextStrain MPXV dataset:
	```unix
	./nextclade dataset get --name 'MPXV' --output-dir 'data/monkeypox'
	```

6. Configure Cecret if desired:
    1. By default Cecret will look for input files at XXX. To change this location, edit line XXX of the cecret.config file.
    2. This workflow uses [this reference genome](https://www.ncbi.nlm.nih.gov/nuccore/NC_063383) by default. To use a different reference genome, move the fasta file to `/PATH/TO/cecret_working_directory/fastas/`.
7. Run the Snakemake workflow located at XXX within the GitHub repository, and run it using the command `XXX`. Under the hood, this workflow will do the following things:
    1. Use sbatch to submit a Slurm job array to use Cecret to assemble the reads for each of the samples you input.
        - Note: If you are in a shared group folder, you may need to edit line XXX of the Snakemake workflow to run this sbatch command using sg. The syntax is `sg <GROUP_NAME> "sbatch <ORIGINAL_JOB_SCRIPT_PATH>"`.
    2. Use Python to generate a figure showing the genome coverage plotted against the coverage depth for each of your samples.
    3. Use sbatch to submit a Slurm job [check with Zach: is it a single job or a job array?] to run Nextclade to assign lineages to your submitted samples. This will create a JSON output file.
    4. If you included geographical metadata for your samples, Snakemake will use Python to generate a chart showing the geographic distribuion of the different lineages in your samples.
8. Finally, take the JSON output from Nextclade (titled `nextclade.auspice.json`) and upload it to [Auspice.us](auspice.us) via drag & drop to visualize the lineage tree for your samples and see how they compare to other publicly available monkeypox virus samples. Scroll to the bottom to the filters and toggle "Filter by Node type" to "New "
