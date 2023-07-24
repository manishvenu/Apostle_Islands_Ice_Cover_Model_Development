#########. barplot settings #######################################################################################

dev.new()
df=array(0,dim=number_of_years)
df[which(is.na(date_num))]=1
df.bar <- barplot(df)
dev.off()

dev.new()
dfd=array(0,dim=number_of_years)
dfd[which(is.na(date_num))]=180
dfd.bar <- barplot(dfd)
dev.off()


########PLOT cox model and beta model validation########################################################################################


if (export_plots_to_plots_folder) {
  plotname=file.path(plot_dir,"validation_stepwise.pdf") #Comment for SIP
  pdf(file=plotname, width = 7.5, height = 5, paper = "special") #Comment for SIP
  
}

betacpt=array(NA)
betacptcv=array(NA)
betanorm=array(NA)
betanormcv=array(NA)
for (i in 1:length(pr_pr_beta))
{
  betacpt[i] = 1-pr_pr_beta_cpt[i]
  betacptcv[i] = 1-pr_pr_beta_cpt_cv[i]
  betanorm[i] = 1-pr_pr_beta[i]
  betanormcv[i] = 1-pr_pr_beta_cv[i]
}
par(mfrow = c(2,2))
par(oma = c(3,5,3,4))
par(mar = c(0,0,0,0))
barplot(dfd,ylim=c(18,100),axes=FALSE,border=NA)
points(dfd.bar,date_num,type='p',pch=20,cex=1.1,col="black")
points(dfd.bar,date_cox,type='p',pch=20,cex=0.6,col="red")
points(dfd.bar,date_cox_cv,type='p',pch=1,cex=1,col="red")
box()
axis(2, at = c(1,32,63,91, 122,152), labels = month.abb[month1])
axis(3,at=df.bar[seq(3,50,5)],labels=seq(1975,2020,5))

mtext("Onset of ice cover", side = 2, line = 3.75)
mtext("(Cox model)", 2,line= 2.25)


barplot(dfd,ylim=c(18,100),axes=FALSE,border=NA, ylab = 'ice onset date')
points(dfd.bar,date_num,type='p',pch=20,cex=1.1,col="black")
points(dfd.bar,date_cox_cpt,type='p',pch=20,cex=0.6,col="red")
points(dfd.bar,date_cox_cpt_cv,type='p',pch=1,cex=1,col="red")
axis(3, labels = FALSE)
axis(4, at = c(1,32,63,91, 122,152), labels = FALSE)
box()

barplot(df,ylim=c(-0.05,1.10),axes=FALSE,border=NA)
points(x = df.bar,y=betanorm,type='p',pch=20,cex=0.6,col="red")
points(x = df.bar,y=betanormcv,type='p',pch=1,cex=1,col="red")
box()
axis(2, labels = FALSE)
axis(1,at=df.bar[seq(3,50,5)],labels=FALSE)
mtext("Probabilty of ice cover", 2,line= 3.75)
mtext("(beta model)", 2,line= 2.25)
barplot(df,ylim=c(-0.05,1.10),axes=FALSE,border=NA, ylab = 'probability of ice absence for beta')
points(x = df.bar,y=betacpt,type='p',pch=20,cex=0.6,col="red")
points(x = df.bar,y=betacptcv,type='p',pch=1,cex=1,col="red")
box()
axis(4)
axis(1,at=df.bar[seq(3,50,5)],labels=seq(1975,2020,5))

if (export_plots_to_plots_folder) {
  dev.off() #Comment for SIP
  
}
