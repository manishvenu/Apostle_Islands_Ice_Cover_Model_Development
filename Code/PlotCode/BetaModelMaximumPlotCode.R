############# PLOT: beta model maximum of 10-day average ice cover#########################################################

if (export_plots_to_plots_folder) {
  plotname=file.path(plot_dir,"Beta_model_Seasonal_Max_Ice cover.pdf") #Comment for SIP
  pdf(file=plotname, height = 4.5, width = 8, paper = "special") #Comment for SIP
  
}
plot(avg10day.max, type = "n", axes = FALSE, ylim = c(0, 100), xlim = c(1, number_of_years),xlab="Ice year",
     ylab="Maximum of 10-day average Ice cover %"); box()
axis(1,at = seq(1, 48, 5), labels = seq(1973,2020, 5))
axis(2)
for(i in 1:number_of_years){
  # segments(i,lw_bound[i]*100,x1=i,y1=up_bound[i]*100, col="dimgrey")   # based on quantiles 
  segments(i,lw.bounds[i]*100,x1=i,y1=up.bounds[i]*100, col="dimgrey")   # based on HPD region
  segments(i,lw.iqr[i]*100,x1=i,y1=up.iqr[i]*100, lwd = 2.5, col="black")   # based on HPD region
}
points(avg10day.max*100,type='p',pch=20,cex=1.1,col="red")

x0=c(1,number_of_years)
y0=c(0.9,0.9)
points(x0,y0*100,type='l',col='blue')
if (export_plots_to_plots_folder) {
  dev.off() #Comment for SIP
}
