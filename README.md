
# The mitochondrial genome of *Erysiphe necator*
This repository contains scripts that I used for the analysis of the mitochondrial genome of the grape powdery mildew pathogen *Erysiphe necator* (GenBank [MT880588.1](https://www.ncbi.nlm.nih.gov/nuccore/MT880588.1/)). The genome and comparative analysis were published in [Zaccaron et al. (2021)](https://www.nature.com/articles/s41598-021-93481-5).


Some of the analysis were performed with [snakemake](https://snakemake.readthedocs.io/en/stable/) to facilitate reproducibility and documentation. The `Snakefiles` utilized are in this repository.

In order to run the `Snakefiles`, you will need to have [bioconda](https://bioconda.github.io/user/install.html) installed. When it is set up, install `snakemake`, like:

```bash
conda install -c bioconda snakemake-minimal
```

There are README.md files with some details in each subdirectory. But you should be able to run the `Snakefile` in the respective subdirectory by:

```bash=
snakemake -j 1 --use-conda
```
