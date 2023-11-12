if (export_plots_to_plots_folder) {
  plotname=   file.path(plot_dir,"yearly_ice_cover.pdf")
  pdf(file=plotname, height = 6, width = 9, paper = "special")
}
  par(mfrow = c(5, 10))
  par(oma = c(6,5,1,4))
  par(mar = c(0,0,0,0))
  for (i in first_year:last_year){ #TU
    yr.index=array(NA)
    count=1
    for (j in 1:length(daily.ice$day_number)){
      if(daily.ice$year[j]==i){
        yr.index[count]=j
        count=count+1
      }
    }
    plot(daily.ice$ice[yr.index], type = "l",xlim = c(0, 210),ylim = c(0, 120), axes=FALSE, xlab=''); box()
    lines(daily.ice$avg10day_ice[yr.index], col = "red")
    abline(h = 90, col = "blue")
    text(x=175,y=110,i, cex = 0.9)
    if((i-1983)%%20==0){
      axis(2,at=c(0,20,40,60,80,100),labels=c(0,20,40,60,80,100))
    }
    if((i-1982)%%20==0){
      axis(4,at=c(0,20,40,60,80,100),labels=c(0,20,40,60,80,100))
    }
    if(i %in% c(2021,2013,2015, 2017, 2019)){
      axis(1, at = seq(2, 180, 30), labels = c("D","J","F","M","A","M"))
    }
    if(i==1993){
      mtext("Ice cover area (%)",2,line=3.5)
    }
  }
  
  if (export_plots_to_plots_folder) {
    dev.off() 
    
  }
