### `rnaseq_hisat`
In this folder there's a `Snakefile` that downloads an RNAseq dataset of *E. necator* corresponding to 4 time points with three reps during interaction with its host (grape). Reads are trimmed and then mapped to the mt genome with `HISAT2`. Even though there are more than 300M reads, less than 3k reads map to the mt genome. The low number of mapped reads prohibited inspection of the gene annotation.


```bash
snakemake -j 1 --use-conda
```

Mapped reads will be in `{sample}.bam`.
