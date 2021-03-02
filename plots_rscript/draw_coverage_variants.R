
#=============================
#function to add features (genes) at specific height (y). The format is gff with an additional column with color
add_features <- function(features, y){
  #draw genes first
  sub_features = subset(features, feature=="gene")
  for(i in 1:nrow(sub_features)){
    color = as.character(sub_features[i,'color'])
    rect(sub_features[i,'start'], y, sub_features[i,'end'], y+40, lwd = 0.2, col = color)
  }
  
  #now draw exons in color
  sub_features = subset(features, feature!="gene")
  for(i in 1:nrow(sub_features)){
    color = as.character(sub_features[i,'color'])
    rect(sub_features[i,'start'], y, sub_features[i,'end'], y+40, lwd = 0.2, col = color)
  }
  
}

#=============================



#======== READING DATA ===========
# gff files with an additional column with color
enec_gff = read.table("enec_genes.gff", sep = '\t', comment.char = "@",col.names = 
                        c("scaff", "note", "feature", "start", "end", "score", "strand", "frame", "tags", "color"))
branching_cov = read.table("../snps/SRR1448453.regions.bed", sep = '\t', col.names = 
                             c("scaff", "start", "end", "cov"))
e1101_cov = read.table("../snps/SRR1448468.regions.bed", sep = '\t', col.names = 
                             c("scaff", "start", "end", "cov"))
lodi_cov = read.table("../snps/SRR1448470.regions.bed", sep = '\t', col.names = 
                         c("scaff", "start", "end", "cov"))
ranch9_cov = read.table("../snps/SRR1448454.regions.bed", sep = '\t', col.names = 
                         c("scaff", "start", "end", "cov"))
indels_vcf = read.table("../snps/variants_filt_INDELs.recode.vcf", sep = '\t', comment.char = "#" )
snps_vcf   = read.table("../snps/variants_filt_SNPs.recode.vcf", sep = '\t', comment.char = "#" )
indels_hist   = read.table("../snps/variants_filt_INDELs_hist.bed", sep = '\t', col.names =
                         c("scaff", "start", "end", "count"))
#================================


#Size of the genome
enec_size = 188577


#======== MAIN =======
pdf("03other_strains_coverage.pdf", width = 10, height = 4.5)
#making an empty plot
plot(1, type="n", xlim=c(0,200000), ylim=c(-80,300), axes = F, xlab = "", ylab = "")
axis(1)
axis(2, at=c(100,150,200,250,300))
axis(2, at=c(0,60) )
mtext("Coverage", side=2, line = 2)
mtext("Position", side=1, line = 2)

#ading segment to represent the genomes
segments(0,-60,enec_size,-60, lwd=4)

#adding features. Adjust height (second argument) if needed
add_features(enec_gff, -80)

lines(branching_cov$start, branching_cov$cov, col="#00798c", lwd=1.5)
lines(e1101_cov$start, e1101_cov$cov, col="#edae49", lwd=1.5)
lines(lodi_cov$start, lodi_cov$cov, col="#66a182", lwd=1.5)
lines(ranch9_cov$start, ranch9_cov$cov, col="#d1495b", lwd=1.5)

points(snps_vcf[,2], rep(-20, nrow(snps_vcf)), pch = 25, col = "black", bg="black")

#legend("topleft", lty = 1, col=c("blue", "orange", "green3", "red"), legend = c("branching", "e1-101", "lodi", "ranch-9"), lwd=2)


#-=-
for(i in 1:nrow(indels_hist)){
  rect(indels_hist[i, 'start'], 0, indels_hist[i, 'end'], indels_hist[i, 'count']*10, border = NA, col="black")
}
#-=-


dev.off()
# plot_crop("00Bgt_Enec_mt_synteny.pdf")
#=================


