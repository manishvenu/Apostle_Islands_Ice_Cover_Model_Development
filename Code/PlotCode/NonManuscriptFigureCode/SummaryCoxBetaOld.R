#######PLOT summary#########################################################################################

new.seg = date_num-date_cox_cpt; new.seg
if(export_plots_to_plots_folder) {
  plotname=file.path(plot_unused_dir,"summaryCoxBetaOld.pdf") 
  pdf(file=plotname, height = 4, width = 6.5, paper = "special")
  
}
par(mar = c(3,4,1,1))
plot(date_num, type = "n", axes = FALSE, ylim = c(20, 105), xlim = c(1,number_of_years), ylab = '', xlab = ''); box()
for(i in 1:number_of_years){
  if((1-pr_pr_beta_cpt[i]) >= 0.5){
    if(new.seg[i] >=0 && !is.na(new.seg[i])){
      segments(x0 = i, y0 = date_cox_cpt[i], y1 = date_num[i]+0.5, col = "grey")
    }
    else{segments(x0 = i, y0 = date_cox_cpt[i], y1 = date_num[i]+0.5, col = "grey", lty = 2)}
    
  }
  else{
    points(i,date_cox_cpt[i],type="p",pch=1,cex=1,col="red")
  }
  points(date_num,pch=20,cex=0.9,col="black")
}
axis(1,at=seq(1,48,5),labels=seq(1973,2020,5), tck = -0.03)
axis(1, at = seq(1,number_of_years), labels = FALSE, tck = -0.009)
month <- c(12,1,2,3,4)
axis(2, at = c(1,32,63,91, 122), labels = month.abb[month])

if(export_plots_to_plots_folder) {
  dev.off() 
  
}