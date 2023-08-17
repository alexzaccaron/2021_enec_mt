### `snps`

The purpose of this Snakemake pipeline is to call variants in the mitochondrial genome of *E. necator*.

To execute the pipeline:

```bash
snakemake -j 1 --use-conda p
```

Parameters:

* `-j 1`: sets the number of cores to use.
* `--use-conda`: create a local conda environment where circos will be installed. Note the software to be installed (entrez-direct, fastp, hisat2, and SAMtools) is defined in the `myenv.yml` file.
* `-p`: print the shell commands that will be executed.

A brief description of what the rules in the `Snakefile` are doing is given below:

* `download_reads`, `download_mt_genome`: rules that download from NCBI reads from different isolates and the mt genome. Reads accession numbers, download links, and strain names are specified in the file `samples.txt`, which is used to by the rule `download_reads` to dynamically download the reads.
* `fastp_trim`: trims low quality bases and barcode/adaptors from the reads.
* `bbduk`: performs kmer matching to extract reads that match to the mt genome.
* `bbnorm`: normalize coverage of the reads to a "normal" value. This is because the mtDNA is highly represented among the WGS reads. The expected coverage is in the range of many hundreds to thousands, which can be problematic for variant calling, or time consuming at the least.
* `read_map`: map the reads to the mt genome.
* `get_coverage`: get coverage of the mapped reads across the mt genome.
* `add_RG`: add read group names to the produced BAM files.
* `make_bam_fof`: produced a list of BAM files to be used by freebayes
* `freebayes`: performs variant calling.
* `vcftools`: filters variants based on mapQ values.
* `prepare_snpeffconfig`: prepare files to generate a custom database for SnpEff, which is used to annotate the variants called. Basically, it adds metadata about the mt genome (including the nonstandard codon table of Mold Mitochondrial to use) to the file `snpEff.config`.
* `build_snpeffDB`: builds the SnpEff database.
* `snpeff_ann`: annotates the variants based on the created custom SnpEff database.
* `split_SNPs_INDELs`: splits the variants into SNPs (or MNPs) and INDELs.
* `INDEL_histogram`: splits the mt genome into chunks (i.e., windows), and count the number of INDELs within exach window.

The R script `scripts/draw_coverage_variants.R` creates a plot of the coverage, the histogram of INDELs and location of SNPs across the mt genome.

A rule graph is shown below, produced with:

```
snakemake -n --rulegraph | dot -Tpdf > dag.pdf
```

![Snakefile rulegraph](dag.pdf "Rulegraph")



