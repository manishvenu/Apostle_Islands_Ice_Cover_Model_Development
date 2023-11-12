###################PLOT: teleconnection indices##########################################################
if (export_plots_to_plots_folder) {
  plotname = file.path(plot_unused_dir, "telec_index.pdf") #Comment to SIP
  pdf(file=plotname) #Comment to SIP
}

par(mfrow = c(5,6))
par(oma = c(3,4.5,3,1))
par(mar = c(0.5,0,0.5,0))

### j is the month and i is the column number 
for (j in 8:12){
  index<-which(tele_data[,2] == j)
  for (i in 3:8){
    plot(tele_data[index,i], type = "n",ylim=c(-3.5,3.5), axes = FALSE);
    ct=length(index)
    for (k in 1:ct){
      if(tele_data[index[k],i]>=0){
        segments(x0=(tele_data[index[k],1]-1971),y0=0,
                 y1=tele_data[index[k],i],lwd = 1.3, 
                 lend = 2,col = "forest green")
      }
      else{
        segments(x0=(tele_data[index[k],1]-1971),y0=0,
                 y1=tele_data[index[k],i],lwd = 1.3, 
                 lend = 2,col = "dark orange")
      }
    }
    ###	  points(avg_data[,8],type="l",ylim=c(0,1))
    
    box()
    if(j==8){
      mtext(index.names[i],side=3,line=0.5)
    }
    #axis
    if (i == 3){
      axis(2)
      mtext(month.abb[j],side=2,line=3)
    }
    if (j == 12){
      if ((i-1)%%2 == 0){
        axis(1,at = seq(1, 48, 5), labels = seq(1972,2020, 5))
      }
    }
  }
}
if (export_plots_to_plots_folder) {
  dev.off() #Comment to SIP
  
}