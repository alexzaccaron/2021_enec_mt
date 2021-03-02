if (!require("ggplot2")){ 
        install.packages("ggplot2") 
} 
library(ggplot2)

# get names of files where tables are
filenames = list.files("../mt_genome_coverage", pattern="*mapped_reads.txt", full.names=T)

# initializing an empty variable
tab = NULL

# for each file, read table and combine with initialized variable
for(filename in filenames){
   aux = read.table(filename, sep='\t'); 
   tab = rbind(tab, aux)
   }

# give name to columns
colnames(tab) = c("isolate", "read_type", "n_reads")

# get rid of total mapped reads. This should be equal to number reads mapped to the nuclear genome + number of reads mapped to the mt genome
tab = subset(tab, read_type!="totalmapped")

# make a bar plot with % of each read type
pdf("percentage_mapped_reads.pdf", width = 5, height = 4)
ggplot(tab, aes(fill=read_type, y=n_reads, x=isolate)) +
   geom_bar(position="fill", stat="identity")+
   theme_classic()
dev.off()
