
# 2021_enec_mt
Scripts utilized for the analysis of the mitochondrial genome of the grape powdery mildew pathogen *Erysiphe necator* (GenBank [MT880588.1](https://www.ncbi.nlm.nih.gov/nuccore/MT880588.1/)). The genome and comparative analysis were published in `[fill the gap]`.


Some of the analysis were performed with [snakemake](https://snakemake.readthedocs.io/en/stable/) to facilitate reproducibility and documentation. The `Snakefiles` utilized are in this repository.

In order to run the `Snakefiles`, you will need to have [bioconda](https://bioconda.github.io/user/install.html) installed. When it is set up, install `snakemake`, like:
```bash=
conda install -c bioconda snakemake-minimal
```

That's it. You should be able to run the `Snakefile` in the current directory by:
```bash=
snakemake -j 1 
```

Below is a summarized description of the directories and scripts.

### `circos`
In this folder there are the files used to construct the circos plot shown in the manuscript. There are several files that contain the coordinates of genes, introns, and ORFs. Just run the `Snakefile` and the figure should be created.

### `genome_size_kmer_count`
In this folder there's a `Snakefile` that downloads WGS reads for five *E. necator* isolates and then estimates the nuclear genome size based on *k*-mer counting with BBMap. The genome size is estimated twice: first with all reads, then after filtering out reads that match the mt genome. They produce different estimates:
+ with all reads: 104 Mb to 149 Mb
+ with mtDNA filtered reads: 76 Mb to 78 Mb

The reference genome of *E. necator* published in [Jones et al. 2014](https://link.springer.com/article/10.1186/1471-2164-15-1081) reports a genome size of 126 Mb, which is likely inflated due to the overrepresentation of the mt genome among the reads.


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
This folder contains files utilized to construct the mitochondrial genome phylogenetic tree. `main_table.csv` contains the GenBank accession numbers of the genes and taxonomic information of the species. The auxiliary R script `scripts/melt_main_table.R` produces a melted (long format) of `main_table.csv`. The script relies on the `reshape` package. It can be called as:
```r=
Rscript aux_scripts/melt_man_table.R main_table.csv main_table_melt.txt
```
The snakefile will read accessions from the melted table (it should exist first) and start downloading protein sequences from NCBI. Sequences are then grouped by gene and aligned. After removal of gaps from the alignments, a concatenated fasta alignment is generated. This alignment is then converted to nexus format in order to run MrBayes. Because MrBayes keeps running, you can cancel it with `ctrl-c` when you see low values of average standard deviation of split frequencies (< 0.01), which is typically considered convergence.

Output of MrBayes will be in `concatenated_alignment/`.

###### tags: `readme` `mt`
