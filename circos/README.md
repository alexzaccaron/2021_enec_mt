### `Circos`

In this folder there are the files used to construct a circos plot for the circular mitochondrial genome. Call snakemake:

```bash
snakemake -j 1 --use-conda -p
```

Parameters:

* `-j 1`: sets the number of cores to use.
* `--use-conda`: create a local conda environment where circos will be installed. Note the software to be installed (only circos v0.69.8) is defined in the `env.yml` file.
* `-p`: print the shell commands that will be executed.

Note the configuration file `circos.conf` that has parameters specific to circos and points to other files in the folders `feature_coordinates`, which contains genes and introns coordinates, and `circos_files`, which constains other configuration files to run circos.


The resulting figure is this:

![circos](./circos.svg)

Note that the raw figure produced by running this snakemake pipeline is different from the [figure published in the article](https://www.nature.com/articles/s41598-021-93481-5/figures/1). This is because I edited the figure in Inkscape to add the proper labels.