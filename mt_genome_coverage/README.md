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



