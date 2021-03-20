### `genome_size_kmer_count`
In this folder there's a `Snakefile` that downloads WGS reads for five *E. necator* isolates and then estimates the nuclear genome size based on *k*-mer counting with BBMap. The genome size is estimated twice: first with all reads, then after filtering out reads that match the mt genome. They produce different estimates:
+ with all reads: 104 Mb to 149 Mb
+ with mtDNA filtered reads: 76 Mb to 78 Mb

The reference genome of *E. necator* published in [Jones et al. 2014](https://link.springer.com/article/10.1186/1471-2164-15-1081) reports a genome size of 126 Mb, which is likely inflated due to the overrepresentation of the mt genome among the reads.



To run:

```bash
snakemake -j 1 --use-conda
```

