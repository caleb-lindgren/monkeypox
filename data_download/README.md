# Data download

Using NCBI SRA's prefetch

## Instructions

1. Install Entrez Direct following the instructions at [https://www.ncbi.nlm.nih.gov/books/NBK179288/](https://www.ncbi.nlm.nih.gov/books/NBK179288/)

    - Note: If you may get any errors like the following:

        ```
        gzip: rchive.Linux.gz: invalid compressed data--format violated
        chmod: cannot access 'rchive.Linux': No such file or directory

        gzip: transmute.Linux.gz: invalid compressed data--format violated
        chmod: cannot access 'transmute.Linux': No such file or directory
        ```

    - In that case, you'll need to manually download and extract (use `gunzip`) the affected files, change their permissions to make them executable (e.g. `chmod +x transmute.Linux`), then put them in your `edirect` install directory (usually `$HOME/edirect`). The base URL the files are located at is [ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/](ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/); just append whatever file you need to the end of that and download it with `wget` or `curl`. E.g. for the two error messages I listed above as examples, you'd need to download `rchive.Linux.gz` and `transmute.Linux.gz`. See [https://www.biostars.org/p/9495108/](https://www.biostars.org/p/9495108/) for more info.
    - After installing, you can check that your `edirect` installation was successful using the script at [https://dataguide.nlm.nih.gov/edirect/install.html#test-your-edirect-installation](https://dataguide.nlm.nih.gov/edirect/install.html#test-your-edirect-installation)

2. Install the SRA Toolkit following the instructions at https://github.com/ncbi/sra-tools/wiki/02.-Installing-SRA-Toolkit
