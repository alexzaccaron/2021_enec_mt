### `snps`
In this directory there's a `Snakefile` that was utilized to call SNPs and INDELs in the mt genome. First, reads that match the mt genome are extracted with `bbduk` and then have their coverage normalized to 100x with `bbnorm`. The normalized reads are then mapped to the mt genome with `BWA-MEM`, PCR duplicates are marked with `samblaster` and `samtools` sorts the alignment to a BAM file. `mosdepth` is utilized to calculate the coverage across the mt genome with a sliding window. SNPs and INDELs are called with `FreeBayes` and then they are filtered with `VCFtools` with minQ of 30. Variants are annotated with `SnpEff`. To do so, `SnpEff` constructs a database from the GenBank file of the mt genome. I made sure to add the codon table `Mold_Mitochondrial` in the condig file of `SnpEff`. `VCFtools` splits the VCF file into SNPs and INDELs, and a histogram of INDELs across the mt genome is generated with `BEDTtools`.

The R script `draw_coverage_variants.R` creates a plot of the coverage, the histogram of INDELs and location of SNPs across the mt genome.


