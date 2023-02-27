# Reads preprocessing and assembly

### useful sources

- [most helpful tutorial for installing/using cecret](https://www.protocols.io/view/cecret-workflow-for-sars-cov-2-assembly-and-lineag-by72pzqe.html)
- [cecret github](https://github.com/UPHL-BioNGS/Cecret)

### installing cecret locally

```
git clone https://github.com/StaPH-B/staphb_toolkit.git
cd staphb_toolkit/packaging/
python3 setup.py install --user
cd ../
export PATH=$PATH:$(pwd)
```

### running cecret

I've been able to get Cecret to run inside the `test_dir_cecret` by installing Cecret using the lines of code above and then running the following:
```
staphb-tk cecret -c cecret.config
```

Cecret looks for a few folders to find the reference and read files. The MPXV reference file is found in `fastas` and the reads are located in `reads` and single_reads` depending on whether they're paired.

I'm working on getting everything working on Docker too (see below)

### Docker Progress

Build the container image using this code
```
docker build -t staphb_toolkit .
```
Run the container using this code. Apparently it's to connect the host docker socket to the kernel's. I can't remember if this part works yet though.
```
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock staphb_toolkit bash
```

For some reason the `cd` and `python3` commands of the cecret installation aren't running automatically in the first code block in the Dockerfile, take a look at that. 


### future

- [ ] the config file still needs to be adjusted 
- [ ] need to get cecret to run from nextflow 
