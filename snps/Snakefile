SAMPLES=["lodi", "ranch9"]


rule all:
    input: 
       expand("{sample}_QCd_duk_norm_R1.fastq.gz", sample=SAMPLES),
       expand("{sample}_QCd_duk_norm_R2.fastq.gz", sample=SAMPLES),
       expand("{sample}_dedup_sorted.bam", sample=SAMPLES),
       expand("{sample}_dedup_sorted_rg.bam", sample=SAMPLES),
       "bams.fof",
       "variants.vcf",
       "variants_filt.recode.vcf",
       "GCA_000798715.1.fasta",  # reference genome of C-strain
       "GCA_000798715.1.gff"     # reference annotation of C-strain

rule download:
   output: 
      lodir1="lodi_R1.fastq.gz", 
      lodir2="lodi_R2.fastq.gz",
      ranch9r1="ranch9_R1.fastq.gz", 
      ranch9r2="ranch9_R2.fastq.gz"
   shell: """
      curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR144/000/SRR1448470/SRR1448470_1.fastq.gz -o {output.lodir1}
      curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR144/000/SRR1448470/SRR1448470_2.fastq.gz -o {output.lodir2}
      curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR144/000/SRR1448454/SRR1448454_1.fastq.gz -o {output.ranch9r1}
      curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR144/000/SRR1448454/SRR1448454_2.fastq.gz -o {output.ranch9r2}
    """


rule download_genome:
   output: fasta="GCA_000798715.1.fasta.gz", ann="GCA_000798715.1.gff.gz"
   shell: """
       curl -L ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/798/715/GCA_000798715.1_ASM79871v1/GCA_000798715.1_ASM79871v1_genomic.fna.gz -o {output.fasta}
       curl -L ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/798/715/GCA_000798715.1_ASM79871v1/GCA_000798715.1_ASM79871v1_genomic.gff.gz -o {output.ann}
"""

rule gzip_genome:
   input: fasta="GCA_000798715.1.fasta.gz", ann="GCA_000798715.1.gff.gz"
   output: fasta="GCA_000798715.1.fasta", ann="GCA_000798715.1.gff"
   shell: """
       gunzip -c {input.fasta} > {output.fasta}
       gunzip -c {input.ann} > {output.ann}
"""

rule fastp_trim:
   conda: "env-preprocess.yml"
   input: r1="{sample}_R1.fastq.gz", r2="{sample}_R2.fastq.gz"
   output: r1="{sample}_QCd_R1.fastq.gz", r2="{sample}_QCd_R2.fastq.gz", html="{sample}_fastp.html", json="{sample}_fastp.json"
   shell: """
      fastp --in1 {input.r1} --in2 {input.r2} --out1 {output.r1} --out2 {output.r2} --html {output.html} --json {output.json} --thread 6 --length_required 40
   """

rule bbduk:
   conda: "env-preprocess.yml"
   input: r1="{sample}_QCd_R1.fastq.gz", r2="{sample}_QCd_R2.fastq.gz", ref="MT880588.1.fasta"
   output: r1="{sample}_QCd_duk_R1.fastq.gz", r2="{sample}_QCd_duk_R2.fastq.gz", stats="{sample}_QCd_bbduk.txt", 
   shell: """
      bbduk.sh in={input.r1} in2={input.r2} outm={output.r1} outm2={output.r2} ref={input.ref} k=31 hdist=1 stats={output.stats} threads=6
   """


rule bbnorm:
   conda: "env-preprocess.yml"
   input: r1="{sample}_QCd_duk_R1.fastq.gz", r2="{sample}_QCd_duk_R2.fastq.gz"
   output: r1="{sample}_QCd_duk_norm_R1.fastq.gz", r2="{sample}_QCd_duk_norm_R2.fastq.gz"
   shell: """
      bbnorm.sh in={input.r1} in2={input.r2} out={output.r1} out2={output.r2} target=100 threads=6 k=31
   """


rule read_map:
   conda: "env-preprocess.yml"
   input: r1="{sample}_QCd_duk_norm_R1.fastq.gz", r2="{sample}_QCd_duk_norm_R2.fastq.gz", ref="MT880588.1.fasta"
   output: bam="{sample}_dedup_sorted.bam"
   shell: """
      bwa index {input.ref}
      bwa mem  \
           -M -t 4 {input.ref} {input.r1} {input.r2} | samblaster | samtools sort -o {output.bam}
   """


rule add_RG:
   conda: "env-preprocess.yml"
   input: bam="{sample}_dedup_sorted.bam"
   output: bam="{sample}_dedup_sorted_rg.bam"
   shell: """
      bamaddrg -b {input.bam} -s {wildcards.sample} -r {wildcards.sample} > {output.bam}

   """

rule make_bam_fof:
   output: "bams.fof"
   shell: """
      ls *_rg.bam > {output}
   """ 
   
rule freebayes:
   conda: "env-freebayes.yml"
   input: ref="MT880588.1.fasta", lodi="lodi_dedup_sorted.bam"
   output: vcf="variants.vcf"
   shell: """
      freebayes -f {input.ref} --ploidy 1 -L bams.fof > {output.vcf}
   """

rule vcftools:
   conda: "env-freebayes.yml"
   input: "variants.vcf"
   output: "variants_filt.recode.vcf"
   shell: """
      vcftools --vcf {input} --minQ 30 --recode --recode-INFO-all --out variants_filt
   """


rule prepare_snpeffconfig:
   conda: "env-snpeff.yml"
   input: gbk="MT880588.1.gbk"
   shell: """
       SNPEFF_CONFIG=$(find .snakemake/conda/ -name snpEff.config)
       SNPEFF_PATH=$(dirname .snakemake/conda/29b5264f/share/snpeff-5.0-0/snpEff.jar)
       echo "# E. necator mt genome"                             >> $SNPEFF_CONFIG
       echo "enec_mt.genome : enec_mt"                           >> $SNPEFF_CONFIG
       echo "enec_mt.MT880588.1.codonTable : Mold_Mitochondrial" >> $SNPEFF_CONFIG
       
       mkdir -p $SNPEFF_PATH/data/enec_mt
       cp {input.gbk} $SNPEFF_PATH/data/enec_mt/genes.gbk
       
   """
   
   
rule build_snpeffDB:
   conda: "env-snpeff.yml"
   shell: """    
       SNPEFF_CONFIG=$(find .snakemake/conda/ -name snpEff.config)  
       snpEff build -config $SNPEFF_CONFIG -genbank -v enec_mt
   """

rule snpeff_ann:
   conda: "env-snpeff.yml"
   input: "variants_filt.recode.vcf"
   output: "variants_filt.recode.ann.vcf"
   shell: """    
       snpEff -v enec_mt {input} > {output}
   """
