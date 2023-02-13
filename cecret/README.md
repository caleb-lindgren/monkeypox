# Reads preprocessing and assembly

### useful sources

- [most helpful tutorial for installing/using cecret](https://www.protocols.io/view/cecret-workflow-for-sars-cov-2-assembly-and-lineag-by72pzqe.html)
- [cecret github](https://github.com/UPHL-BioNGS/Cecret)

### installing cecret

```
git clone https://github.com/StaPH-B/staphb_toolkit.git
cd staphb_toolkit/packaging/
python3 setup.py install --user
cd ../
export PATH=$PATH:$(pwd)
```

### running cecret

this is the code I used 
```
staphb-tk cecret -c cecret.config
```

### future

- [ ] the config file still needs to be adjusted 
- [ ] need to get cecret to run from nextflow 
