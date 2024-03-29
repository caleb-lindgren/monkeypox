# Reads preprocessing and assembly

### useful sources

- [most helpful tutorial for installing/using cecret](https://www.protocols.io/view/cecret-workflow-for-sars-cov-2-assembly-and-lineag-by72pzqe.html)
- [cecret github](https://github.com/UPHL-BioNGS/Cecret)

### installing cecret locally

[These instructions](https://developers.google.com/earth-engine/guides/python_install-conda) were the best I found for installing pip using conda on Linux.
```
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh
rm ~/miniconda.sh
source $HOME/miniconda3/bin/activate

conda install pip
conda install -c conda-forge openjdk=11

# (to add conda to PATH)
printf '\n# add path to conda\nexport PATH="$HOME/miniconda3/bin:$PATH"\n' >> ~/.bashrc
```

Once you have pip installed you should be able to run the following.

```
pip install urllib3==1.26.7 --user
pip install requests==2.26.0 --user

cd staphb_toolkit/packaging/
python3 setup.py install --user
cd ../
export PATH=$PATH:$(pwd)
```

### Initializing on the supercomputer every time (after the first installation)

Once everything is installed you should just need to add staphb-tk to your PATH again

```
source $HOME/miniconda3/bin/activate
conda install pip
pip install urllib3==1.26.7 --user

cd staphb_toolkit/
export PATH=$PATH:$(pwd)

module load singularity

export NXF_SINGULARITY_CACHEDIR=/tmp/monkeypox
mkdir /tmp/monkeypox

```

### running cecret

I've been able to get Cecret to run inside the `test_dir_cecret` by installing Cecret using the lines of code above and then running the following:

*important:* I talked to the LSB RC guy and the only way we could get things working was to copy everything into the `/tmp` directory and create the `/tmp/singularity/mtn/.../` directory if needed

```
staphb-tk cecret -c cecret.config
```

Cecret looks for a few folders to find the reference and read files. The MPXV reference file is found in `fastas` and the reads are located in `reads` and `single_reads` depending on whether they're paired.

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
