
plotting_function <- function(label,data) {
  if (export_plots_to_plots_folder) {
    plotname=file.path(plot_unused_dir,paste0("SV_",label,".pdf")) #Comment to SIP 
    pdf(file=plotname, height = 4, width = 6.5, paper = "special") #Comment to SIP
  }
  par(mfrow = c(1,1))
  par(oma = c(4,4.5,3,1))
  par(mar = c(0.5,0,0.5,0))
  plot(data, axes = FALSE, xlim = c(1,number_of_years), ylab = label, xlab = 'Years', type="l")
  box()
  #points(date_num,type='p',pch=20,cex=0.65, col = "black")
  #points(date_num,type='l')
  #month <- c(12,1,2,3,4)
  axis(2)
  mtext(label, side = 2, line = 3)
  mtext("Years", side = 1, line = 3)
  
  axis(1, at = seq(3, 48, 5), labels = seq(1975,2020, 5), tck = -0.03)
  axis(1, at = seq(1,number_of_years), labels = FALSE, tck = -0.009)
  if (export_plots_to_plots_folder) {
    dev.off()
  }
}
plotting_function("December Temperature",teleall$dec.airTemp)
plotting_function("September EP-NP",teleall$sep.epo)
plotting_function("December OLR",teleall$dec.OLR)
plotting_function("November AO",teleall$nov.ao)
plotting_function("September Temperature",teleall$sep.airTemp)
plotting_function("August Temperature",teleall$aug.airTemp)
plotting_function("November EP-NP",teleall$nov.epo)


