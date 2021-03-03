
# 2021_enec_mt
Scripts utilized for the analysis of the mitochondrial genome of the grape powdery mildew pathogen *Erysiphe necator* (GenBank [MT880588.1](https://www.ncbi.nlm.nih.gov/nuccore/MT880588.1/)). The genome and comparative analysis were published in `[fill the gap]`.


Some of the analysis were performed with [snakemake](https://snakemake.readthedocs.io/en/stable/) to facilitate reproducibility and documentation. The `Snakefiles` utilized are in this repository. However, not all of them are fully automated.

Below is a summarized description of the directories and scripts.

### `circos`
In this folder there are the files used to construct the circos plot shown in the manuscript. Once circos in installed, simply running `circos` inside this directory will produce the plot. Further manual edits were performed for get the final version.

### `mt_genome_coverage`

In this folder, there is a `Snakefile` that will map with `bwa mem` whole-genome sequencing reads of five *E. necator* isolates to the reference nuclear and mitochondrial genomes. It basically does:

- Download the reads and perform quality control with `FastQC` and `fastp`
- Download the nuclear genome (fasta and GFF)
- Remove mitochondrial contigs from the nuclear genome fasta
- Concatenate the filtered fasta with the complete mitochondrial genone
- Generate a BED file with the exons of nuclear genes followed by the mitochondrial genome coordinates (single interval covering all bases)
- Map reads with `BWA-MEM`, mark PCR duplicates with `samblaster` and sort to a BAM file with `samtools`.
- Calculate median coverage of the BED intervals (exons and mt genome) with `mosdepth`
- Count unmapped and mapped reads, and reads mapped to the nuclear and mt genome with `samtools`


The R script `percentage_mapped_reads.R` makes a bar chart of the percentages of the reads unmapped and that mapped to the nuclear and mt genomes. The R script `predict_mt_copynumber.R` predicts the mt genome copy number as the ratio of the mt genome coverage and the nuclear genome coverage. It will read the output of `mosdepth` and get rid of outliers (top 1% exons with lowest and highest coverage). The median coverage of the remaining exons is considered the nuclear genome coverage. For the mt genome coverage, the median of all bases is considered.



### `rnaseq_hisat`
In this folder there's a `Snakefile` that downloads an RNAseq dataset of *E. necator* corresponding to 4 time points with three reps during interaction with its host (grape). Reads are trimmed and then mapped to the mt genome with `HISAT2`. Even though there are more than 300M reads, less than 3k reads map to the mt genome, which prohibited inspection of the gene annotation.



### `snps`
In this directory there's a `Snakefile` that was utilized to call SNPs and INDELs in the mt genome. First, reads that match the mt genome are extracted with `bbduk` and then have their coverage normalized to 100x with `bbnorm`. The normalized reads are then mapped to the mt genome with `BWA-MEM`, PCR duplicates are marked with `samblaster` and `samtools` sorts the alignment to a BAM file. `mosdepth` is utilized to calculate the coverage across the mt genome with a sliding window. SNPs and INDELs are called with `FreeBayes` and then they are filtered with `VCFtools` with minQ of 30. Variants are annotated with `SnpEff`. To do so, `SnpEff` constructs a database from the GenBank file of the mt genome. I made sure to add the codon table `Mold_Mitochondrial` in the condig file of `SnpEff`. `VCFtools` splits the VCF file into SNPs and INDELs, and a histogram of INDELs across the mt genome is generated with `BEDTtools`.

The R script `draw_coverage_variants.R` creates a plot of the coverage, the histogram of INDELs and location of SNPs across the mt genome.



### `tree`
This folder contains files utilized to construct the mitochondrial genome phylogenetic tree. `main_table.csv` presents the GenBank accession numbers of the genes and taxonomic information of the species. The auxiliary R script `melt_main_table.R` produces a melted (long format) of `main_table.csv`. The script relies on the `reshape` package. It can be called as:
```r=
Rscript aux_scripts/melt_man_table.R main_table.csv main_table_melted.txt
```

The `main_table_melted.txt` file can be used to download the sequences with the `download_seqs` rule in the `Snakefile`. But the sequences are already in the `sequences` directory. Name of the files follows the format `<TaxID>_<GeneName>_<Accession>.fasta`. The `Snakefile` will produce a concatenated fasta alignment of the genes *atp6*, *nad1*-*6*, *nad4L*, *cox1*-*3* and *cob*. Since MrBayes only accepts alignments in nexus format (?), I converted the fasta alignment to nexus using [Alter](http://sing-group.org/ALTER/). The alignment in nexus format is already in the `mrbayes` directory. At the end of the nexus file, there is a block of code setting the parameters for MrBayes. So, you can just run:
```bash=
mb concatenated_alignment.nex
```
And MrBayes will construct the tree.

###### tags: `readme` `mt`
