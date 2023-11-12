

if(export_plots_to_plots_folder) {
  plotname=file.path(plot_dir,"yearly_cox_beta_obs.pdf") #Comment for SIP
  pdf(file=plotname, height = 6, width = 9, paper = "special") #Comment for SIP
  
}
par(mfrow = c(5,10))
par(oma = c(8,5,1,4))
par(mar = c(0,0,0,0))
for(i in 1:number_of_years)	{
  plot(survfit(coxfit3, newdata=teleall[i,]),xlim=c(0,183),ylim=c(0,1.2),axes=FALSE,col="blue",conf.int=FALSE, fun = "event")
  points(183,1-pr_pr_beta[i],type='p',pch="-",cex=5,col="forest green")  # adjust y position to acount for pch type offset
  # points(183,1-pr_pr_cox[i], type='p',pch="-",cex=5,col="red")
  points(183, 0.5, cex = 2.5, col = 8, pch= "-")
  abline(v=date_num[i])
  text(x=141,y=1.10,i+1972)
  box()
  if((i-1)%%20==0){
    axis(2,at=c(0.2,0.4,0.6,0.8,1),labels=c(0.2,0.4,0.6,0.8,1))
  }
  if((i)%%20==0){
    axis(4,at=c(0.2,0.4,0.6,0.8,1),labels=c(0.2,0.4,0.6,0.8,1))
  }
  if(i %in% seq(41,49,2)){
    axis(1)
  }
  if(i==21){
    mtext("Probability of ice onset",2,line=3.5)
  }
  if(i==45){
    mtext("Days (after December 1)", 1, line = 3.5, adj = 0)
  }
}

par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE)
plot(0, 0, type = "n", bty = "n", xaxt = "n", yaxt = "n")
legend(x = "bottom",
       legend=c("Observed ice onset","Cox model","beta model", "0.5 probability (ref)"),
       col=c("black","blue","forest green", "grey"),
       lty=c(NA,1,NA, NA),pch=c("|",NA,"-","-"),
       pt.cex = c(1,1,4,3),
       xpd = TRUE, horiz = TRUE, inset = c(0,0), bty = "n", cex=1.2)

if (export_plots_to_plots_folder) {
  dev.off() #Comment for SIP
  
}