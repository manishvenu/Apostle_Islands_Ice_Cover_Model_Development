library(lubridate)
library(stringr)


max_temperature_data_link = "https://www.ncei.noaa.gov/data/nclimdiv-monthly/access/climdiv-tmaxdv-v1.0.0-20231106"
tmax = read.table(max_temperature_data_link, header = F)
names(tmax) = c("Year", month.abb[1:12])

########### FUNCTION FROM SOMEONE ELSE: https://waterprogramming.wordpress.com/2015/12/02/easy-labels-for-multi-panel-plots-in-r/#############################
put.fig.letter <-
  function(label,
           location = "topleft",
           x = NULL,
           y = NULL,
           offset = c(0, 0),
           ...) {
    if (length(label) > 1) {
      warning("length(label) > 1, using label[1]")
    }
    if (is.null(x) | is.null(y)) {
      coords <- switch(
        location,
        topleft = c(0.1, 0.9),
        topcenter = c(0.5525, 0.98),
        topright = c(0.985, 0.98),
        bottomleft = c(0.17, 0.5),
        bottomcenter = c(0.5525, 0.02),
        bottomright = c(0.985, 0.02),
        c(0.015, 0.98)
      )
    } else {
      coords <- c(x, y)
    }
    this.x <- grconvertX(coords[1] + offset[1], from = "nfc", to = "user")
    this.y <- grconvertY(coords[2] + offset[2], from = "nfc", to = "user")
    text(
      labels = label[1],
      x = this.x,
      y = this.y,
      cex = 1,
      xpd = T,
      ...
    )
  }
temp = str_split_fixed(tmax$Year, '27', 2)
tmax$station_num = temp[, 1]
tmax$Year = as.numeric(temp[, 2])
first_year = 1895
last_year = 2023

station_nums_of_interest = c(4701)
station_names = c("North West WI")

for (i in seq_along(station_nums_of_interest)) {
  data = tmax[which(tmax$station_num == station_nums_of_interest[i]), ]
  
  #Iterate in 30 year increments
  thirty_year_seq_end = c(1970,1980,1990,2000,2010,2020)
  thirty_year_seq_start = c(1970-30,1980-30,1990-30,2000-30,2010-30,2020-30)
  
  if (export_plots_to_plots_folder) {
    filename = paste0(station_names[i],"_hist.pdf")
    plotname = file.path("Plots/PresentationFigures/", filename) #Comment to SIP
    pdf(file=plotname,width=12,height=4,paper="special") #Comment to SIP
  }
  par(mfcol= c(1, 6))
  par(mar = c(0, 0, 0, 0))
  par(oma = c(6, 5, 5, 4))
  for (m in c(2)) {
    
    for (y in seq_along(thirty_year_seq_start)) {
      years_of_interest_index = which (data$Year > thirty_year_seq_start[y] &
                                         data$Year < thirty_year_seq_end[y])
      description = paste0(
        thirty_year_seq_start[y],
        " to ",
        thirty_year_seq_end[y]
      )
      if ( m==12) {
        x_min = 8
        x_max = 36
      } else if (m==1){
        x_min = 6
        x_max = 34
      }else {
        x_min = 14
        x_max = 42
      }
      
      h = hist(
        data[years_of_interest_index,m+1],
        main = "",
        ylab = "Count",
        #xlab = "Temperatures (F)",
        breaks = seq(-2,42,2)
        ,ylim=c(0,11),
        xlim = c(x_min, x_max),
        axes = F,
        col = "grey"
      )
      abline(v=mean(data[years_of_interest_index,m+1]),col="red")
      g = data[years_of_interest_index,m+1]
      xfit <- seq(x_min, x_max, length = 40) 
      yfit <- dnorm(xfit, mean = mean(g), sd = sd(g)) 
      yfit <- yfit * diff(h$mids[1:2]) * length(g) 
      
      lines(xfit, yfit, col = "black", lwd = 2)

      if (y == 1) {
        axis(2)
        mtext("Count", side = 2,line=3)
        
      } else if (y==6) {
        axis(4)
      }

      if (y%%2==1) {
        axis(1)
        mtext(description, side = 3,line=2,cex=0.8)
        
      }else {
        axis(3)
        mtext(description, side = 3,line=2,cex=0.8)
        
      }

      
      box()
    }
    #mtext(paste(station_names[i],"Climate Division","February Maximum Temperature Histograms"), side = 3,line=3,
    #      outer = TRUE)
    mtext("Temperature (\u00B0F)", side = 1,line=3,
          outer = TRUE)
  }
  par(fig=c(0, 1, 0, 1), oma=c(0, 0, 0, 0), mar=c(0, 0, 0, 0), new=TRUE)
  plot(0, 0, type='n', bty='n', xaxt='n', yaxt='n')
  legend_name = c("Mean","Fitted Normal Distribution")
  legend("bottomright",bty="n", xpd = TRUE,legend =legend_name,lty=c(1,1),col=c("red","black"),cex=1,border=FALSE)
  if (export_plots_to_plots_folder) {
    dev.off() #Comment to SIP
    
  }
  
}
