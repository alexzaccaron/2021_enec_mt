### `rnaseq_hisat`

The purpose of this Snakemake pipeline is to map RNA-seq reads to the mitochondrial genome of *E. necator*.

To execute the pipeline:

```bash
snakemake -j 1 --use-conda p
```

Parameters:

* `-j 1`: sets the number of cores to use.
* `--use-conda`: create a local conda environment where circos will be installed. Note the software to be installed (entrez-direct, fastp, hisat2, and SAMtools) is defined in the `myenv.yml` file.
* `-p`: print the shell commands that will be executed.

A brief description of what the rules in the `Snakefile` are doing is given below:

* `download_reads` and `download_mt_genome`: these rules will download the reads and a fasta file of the mitochondrial genome from NCBI. Download links for the reads are given in the `samples.txt` file. The rule will dynamically grab the download link and use `curl` to download the fastq files.
* `fastp_trim`: performs the trimming of the RNA-seq reads
* `hisat_build` and `hisat`: builds and index and maps the RNA-seq reads to the mitochondrial genome.
