library(lubridate)
library(stringr)


max_temperature_data_link = "https://www.ncei.noaa.gov/data/nclimdiv-monthly/access/climdiv-tmaxdv-v1.0.0-20231005"
tmax = read.table(max_temperature_data_link, header = F)
names(tmax) = c("Year", month.abb[1:12])

########### FUNCTION FROM SOMEONE ELSE: https://waterprogramming.wordpress.com/2015/12/02/easy-labels-for-multi-panel-plots-in-r/#############################
put.fig.letter <-
  function(label,
           location = "bottomleft",
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
        topleft = c(0.15, 0.9),
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
      cex = 1.5,
      xpd = T,
      ...
    )
  }
temp = str_split_fixed(tmax$Year, '27', 2)
tmax$station_num = temp[, 1]
tmax$Year = as.numeric(temp[, 2])
first_year = 1895
last_year = 2023

station_nums_of_interest = c(2002,2001,4702,4701,2103)
station_names = c("mi_east_upper","mi_west_upper","wi_north_central","wi_northwest","mn_northeast")

for (i in seq_along(station_nums_of_interest)) {
  data = tmax[which(tmax$station_num == station_nums_of_interest[i]), ]
  
  #Iterate in 30 year increments
  thirty_year_seq = seq(first_year, last_year, 30)
  thirty_year_seq[length(thirty_year_seq)] = last_year

  for (m in c(1,2,12)) {
    if (export_plots_to_plots_folder) {
      filename = paste0(station_names[i],"_",month.abb[m],"_hist.pdf")
      plotname = file.path("Plots/ClimateDivisionHistograms/", filename) #Comment to SIP
      pdf(file=plotname,width=12,height=8,paper="special") #Comment to SIP
    }
    par(mfrow = c(4, 1))
    par(mar = c(0, 0, 0, 0))
    par(oma = c(5, 4, 2, 4))
    for (y in seq_along(thirty_year_seq)) {
      if (y == length(thirty_year_seq)) {
        next
      }
      years_of_interest_index = which (mi_east_upper$Year > thirty_year_seq[y] &
                                         mi_east_upper$Year < thirty_year_seq[y + 1])
      description = paste0(
        "Division ",
        station_nums_of_interest[i]," ",
        month.abb[m],
        " Temperatures: ",
        thirty_year_seq[y],
        " to ",
        thirty_year_seq[y + 1]
      )
      
      hist(
        mi_east_upper[years_of_interest_index,m+1],
        main = "",
        ylab = "Count",
        xlab = "Temperatures (F)",
        breaks = seq(4,38,2)
        ,ylim=c(0,10),
        xlim = c(4, 38),
        axes = F,
        col = "lightgrey"
      )
      put.fig.letter(description)
      if (y %% 2 == 1) {
        axis(2)
      } else {
        axis(4)
      }
      if (y == 4) {
        axis(1)
        mtext("Temperature (\u00B0F)", side = 1,line=3,
              outer = TRUE)
      }
      box()
    }
    if (export_plots_to_plots_folder) {
      dev.off() #Comment to SIP
      
    }
    
  }
  
}


## Flatten Matrix
# date = array(NA)
# value = array(NA)
# counter=1
# for (i in seq_along(mi_east_upper$Year)) {
#   for (m in 2:13) {
#     date[counter] =ymd(paste0(mi_east_upper$Year[i],"-",m-1,"-01"))
#     value[counter] = mi_east_upper[i,m]
#     counter = counter+1
#   }
# }
# mi_east_upper_flat = data.frame(Date = date,Tmax = value)

## Histogram by Month ##
