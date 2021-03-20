### `tree`
This folder contains files utilized to construct the mitochondrial genome phylogenetic tree. `main_table.csv` contains the GenBank accession numbers of the genes and taxonomic information of the species. The auxiliary R script `scripts/melt_main_table.R` produces a melted (long format) of `main_table.csv`. The script relies on the `reshape` package. It can be called as:
```r=
Rscript scripts/melt_man_table.R main_table.csv main_table_melt.txt
```
The snakefile will read accessions from the melted table (it should exist first) and start downloading protein sequences from NCBI. Sequences are then grouped by gene and aligned. After removal of gaps from the alignments, a concatenated fasta alignment is generated. This alignment is then converted to nexus format in order to run MrBayes. Because MrBayes keeps running, you can cancel it with `ctrl-c` when you see low values of average standard deviation of split frequencies (< 0.01), which is typically considered convergence.

Output of MrBayes will be in `concatenated_alignment/`.
