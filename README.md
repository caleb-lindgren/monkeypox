# Emerging Viral Strains 

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
- miniconda3/conda 23.3.1
- wget 1.14
- tar 1.26
- xz 5.2.2
- GNU sed 4.2.2
    
Additionally, you will need internet access while you are logged in to the cluster, but computing jobs that you run on the cluster will not require internet access. 

## Instructions for use

First, download the pipeline and run it on our example dataset to ensure that everything is functioning properly on your system:

1. Log in to your high performance computing cluster. 
2. Clone this GitHub repository ([https://github.com/caleb-lindgren/monkeypox](https://github.com/caleb-lindgren/monkeypox)) and enter the directory. You can clone via HTTPS or via SSH:

Clone via HTTPS:

```unix
git clone https://github.com/caleb-lindgren/monkeypox
```

Clone via SSH:

```unix
git clone git@github.com:caleb-lindgren/monkeypox.git
```
Enter the cloned directory:

```unix
cd monkeypox
```
3. Run the bash script `run_all.sh` within the GitHub repository:

```unix
bash run_all.sh
```

This script will download example MPXV reads, assemble them, and perform a lineage analysis using Nextclade. Figures 2 and 3 will be generated and can be found in the `plots_output/` directory.

4. Take the JSON output from Nextclade (located at `nextclade_output/nextclade.auspice.json`) and upload it to [Auspice.us](https://auspice.us/) via drag & drop. This allows you to visualize the lineage tree for your samples and see how they compare to other publicly available monkeypox virus samples. Scroll to the bottom to the filters and toggle "Filter by Node type" to "New". Once visible, the Auspice interface allows for downloading images of the figure.

Now you are ready to process reads from your own samples. To do so, replace the child directories within the `extracted_sra_data/` directory with new child directories containing the single or paired reads from your own samples. You should create one child directory for each of your samples. The name of the each child directory should be the corresponding sample ID, and paired and/or single reads should be organized in child directories within it as follows:
```
extracted_sra_data/
├── <SAMPLE_ID>
│   ├── paired
│   │   ├── <SAMPLE_ID>_1.fastq
│   │   └── <SAMPLE_ID>_2.fastq
│   └── single
│       └── <SAMPLE_ID>.fastq
├── <SAMPLE_ID>
...
```

Then, follow the same steps above to process your data.
