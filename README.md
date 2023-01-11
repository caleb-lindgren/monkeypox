# Emerging Viral Strains 

(DC Public Health, Janis Doss - Janis.doss@dc.gov)

Whole genome sequencing (WGS) has become more prevalent in public health laboratories in recent years due to the COVID-19 pandemic. Many public health labs are now using their enhanced WGS infrastructure to sequence other emerging pathogens; however, bioinformatic methods must be adapted to the organism, resources available, and specific needs of the lab. The largest monkeypox (MPX) outbreak outside of non-endemic areas occurred in 2022 and many public health labs became interested in sequencing MPX for surveillance, outbreak investigations, and research. The MPX virus has some interesting genetic characteristics, such as a large 197 kb genome, the presence of tandem repeats, and a tendency to evolve by gene loss rather than progressive point mutations. Imagine you are the bioinformatician for a lab that is starting to sequence MPX samples. Develop a protocol for MPX bioinformatic analysis, including preprocessing of raw reads, genome assembly, quality assessment, lineage classification, and visualization of results (alignments and trees). You can use fastq files from the NCBI Sequence Read Archive (SRA). If possible, create an automated pipeline/workflow using Nextflow, Galaxy, or other software.
 
Resources that would be helpful for this project would include:
- [NCBI SRA](https://www.ncbi.nlm.nih.gov/sra) to download fastq files
- [Nextclade](https://clades.nextstrain.org/) can do monkeypox lineage classification, alignments, and trees
- [This](https://www.ncbi.nlm.nih.gov/nuccore/NC_063383) is a good reference genome for monkeypox
- There are many free assembly programs, such as [Cecret](https://github.com/UPHL-BioNGS/Cecret)
