# PLOT: teleconnection correlations-----


for(i in 1:5){
mi<-seq(i,215,5)
monthpair<-tele_data_c[mi,]
plotname = paste(plotdir,"month_",monthnames[i], ".pdf", sep = "")
colnames(monthpair)<-paste(monthnames[i],".",colnames(monthpair), sep = "")
pdf(file=plotname)
par(mfrow = c(5,6))
par(oma = c(4,4.5,4,4))
par(mar = c(0.5,0,0.5,0))
print(ggpairs(monthpair))
dev.off()
}

for(i in 1:length(colnames(tele_data_c))){
telepair<-tele_data_c[,i]
telepair<-data.frame(matrix(unlist(t(telepair)),byrow=T,year_len,5))
colnames(telepair)<-paste(monthnames,".",telenames[i], sep = "")
plotname = paste(plotdir,"tele_",telenames[i], ".pdf", sep = "")
pdf(file=plotname)
par(mfrow = c(5,6))
par(oma = c(4,4.5,4,4))
par(mar = c(0.5,0,0.5,0))
print(ggpairs(telepair))
dev.off()
}