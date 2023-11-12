##########################################################
#PLOT with Model Data----
##########################################################
library(Cairo)
beta_alarm=array(NA)
obsnoice = array(NA)
for (i in 1:length(date_num)) {
  if (is.na(date_num[i])) {
    obsnoice[i] = 20
    date_cox_cpt[i] = 0
  }
  else if (date_num[i]==18) {
    obsnoice[i] = 0
  }
}
for (i in 1:length(pr_pr_beta_cpt))
{
  if(pr_pr_beta[i] < 0.50)
  {
    beta_alarm[i]=NA;
  }
  else
  {
    beta_alarm[i]=18;
  }
}
cox_probs_cpt_alarm = array(NA)
for (prob_index in seq_along(cox_probs_cpt)) {
  if (cox_probs_cpt[prob_index]<0.5) {
    cox_probs_cpt_alarm[prob_index] = FALSE
  }else {
    cox_probs_cpt_alarm[prob_index] = TRUE
  }
}

if (export_plots_to_plots_folder) {
  plotname=file.path(plot_dir,"PresentationFigures","presentation_ice_onset_model_summary.pdf")
  CairoPDF(file=plotname, height = 4.5, width = 8, paper = "special") 
  
}
par(mfrow = c(1,1))
par(mar = c(4,4,1,1))
par(oma=c(0,0,0,0))

plot	(date_num, type = "n", axes = FALSE, ylim = c(20, 105), xlim = c(1,number_of_years), ylab = 'Ice Onset Date', xlab = ''); box()
rect(par("usr")[1], par("usr")[3], 25, par("usr")[4], col = 
       "lavenderblush",border=F)
rect(25, par("usr")[3],  par("usr")[2], par("usr")[4], col = 
       "oldlace",border=F)
abline 	(v = which(obsnoice == 20), lwd = 6, col = "darkgrey")
abline 	(v = which(beta_alarm == 18), lwd = 1,col = "blue")
points	(date_num, type='p', pch=20, cex=0.65)
points	(date_num, type='l')
points	(date_cox_cpt, type='p', pch=21, cex=0.85, col="red")
month <- c(12,1,2,3,4)
axis(2, at = c(1,32,63,91, 122), labels = month.abb[month])
axis(1, at = seq(3, 48, 5), labels = seq(1975,2020, 5), tck = -0.03)
axis(1, at = seq(1,number_of_years), labels = FALSE, tck = -0.009)
legend(x = "topleft",legend=c(	"Observed ice onset date",
                               "Simulated ice onset date (cox)", 
                               "No observed ice onset",
                               "No simulated ice onset (beta)"),
       col=c("black","red", "darkgrey", "blue"),
       pch=c(16,1, -124, -124), bty = 'n', cex=0.98,ncol=1)
box()

if (export_plots_to_plots_folder) {
  dev.off() 
  
}
