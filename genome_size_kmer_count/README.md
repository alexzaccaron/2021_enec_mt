### `genome_size_kmer_count`

The purpose of this `Snakefile` is to compare the estimations of the nuclear genome size of *Erysiphe necator* based on 1) all the WGS reads, and 2) all the WGS reads after removing those that originated from the mitochondrial genome.

To run the pipeline:

```bash
snakemake -j 1 --use-conda -p
```
Parameters:

* `-j 1`: sets the number of cores to use.
* `--use-conda`: create a local conda environment where circos will be installed. Note the software to be installed (BBmap and entrez-direct) are defined in the `env.yml` file.
* `-p`: print the shell commands that will be executed.

A brief description of what the rules in the `Snakefile` are doing is given below:

* `download_genome` and `download_reads`: the pipeline will download a fasta of the mitochondrial genome and raw WGS sequencing reads file from NCBI.

* `filter_mtDNA`: create new fastq files that do not contain reads with a k-mer matching the mitochondrial genome
* `estimate_all` and `estimate_filt`: estimate the size of the nuclear genome using all the WGS reads, and all the WGS reads after k-mer filtering.
