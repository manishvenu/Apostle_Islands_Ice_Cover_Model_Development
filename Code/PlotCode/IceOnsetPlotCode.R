###################PLOT: date of seasonal ice onset###############################################
### NOTE: This figure is unused in the 2022 manuscript
if (export_plots_to_plots_folder) {
  plotname=file.path(plot_dir,"ice_onset.pdf") #Comment to SIP 
  pdf(file=plotname, height = 4, width = 6.5, paper = "special") #Comment to SIP
}
  par(mar = c(3,4,1,1))
  plot(date_num, type = "n", axes = FALSE, ylim = c(20, 105), xlim = c(1,number_of_years), ylab = '', xlab = ''); box()
  points(date_num,type='p',pch=20,cex=0.65, col = "black")
  points(date_num,type='l')
  month <- c(12,1,2,3,4)
  axis(2, at = c(1,32,63,91, 122), labels = month.abb[month])
  axis(1, at = seq(3, 48, 5), labels = seq(1975,2020, 5), tck = -0.03)
  axis(1, at = seq(1,number_of_years), labels = FALSE, tck = -0.009)
  mtext("Ice onset date",2,line=3, cex=1.2)
  if (export_plots_to_plots_folder) {
    dev.off()
  }
