if (!require("ggplot2")){ 
        install.packages("ggplot2") 
} 
library(ggplot2)


getCov <- function(tab, prefix){
	
	outliers = quantile(tab$cov, probs = c(0.01, 0.99))

	tab_filt = subset(tab, cov > outliers['1%'] & cov < outliers['99%'])
	nc_cov = median(tab_filt$cov)

	mt_cov = subset(tab, chr=='MT880588.1')$cov

	mt_nc_ratio = mt_cov/nc_cov

	return(c(prefix, nc_cov, mt_cov, mt_nc_ratio))
}


filenames = list.files("./", pattern="*.regions.bed$", full.names=T)

# initializing an empty variable
tab = NULL

# for each file, read table and combine with initialized variable
for(filename in filenames){
   prefix = strsplit(filename, split="/")[[1]]
   prefix = prefix[length(prefix)]
   prefix = strsplit(prefix, split="\\.")[[1]][1]

   aux = read.table(filename, sep='\t', col.names=c("chr", "start", "end", "cov") )
   aux = getCov(aux, prefix)
   tab = rbind(tab, aux)
   }

colnames(tab) = c("isolate", "nc_cov", "mt_cov", "nc_mt_ratio")
tab = as.data.frame(tab)
tab$nc_mt_ratio = as.numeric( tab$nc_mt_ratio )

pdf("plots/predicted_mt_copynumber.pdf", width = 5, height = 4.5)
ggplot(tab, aes(x=isolate, y=nc_mt_ratio)) + 
   geom_bar(stat="identity") + 
   theme_classic() +
   coord_cartesian(ylim = c(0, 400))
dev.off()
