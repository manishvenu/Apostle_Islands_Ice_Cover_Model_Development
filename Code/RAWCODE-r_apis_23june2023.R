


###############################################################
###############################################################
#### R code for APIS manuscript -- 2020 model update
###############################################################
###############################################################

###############################################################
#######Load Libraries########
###############################################################

library(betareg)
library(gamlss)
library(survival)
library(pec)
library(rms)
library(changepoint)
library(XML)
library(rjson)
library(labeling)
library(httr)
library(tidyverse)
library(kableExtra)
library(gt)
library(paletteer) 


## Set Working Directories#####################################


#Set directories to where code is located & where plots should be directed to 
#SIP = Show in Plot. All code to export plots to pdf are commented out!
setwd("Q:\\Hydro\\writing\\submitted\\apostle_islands_redux_manish\\R")
plotdir = "Q:\\Hydro\\writing\\submitted\\apostle_islands_redux_manish\\R\\Plots\\Old_Plots\\TempDump\\"
exportplots=TRUE #TRUE

## Data Handling - Daily Ice Cover########
year_end = 2022
year_start = 1973
year_len = year_end - year_start+1
## filter data so each year is defined as start from Dec to May

daily.ice = read.csv('SpreadsheetData/dailyIceTimeSeries_1973_2022.csv', header = FALSE, sep = ",") #replace with file generated in above code
daily.ice.Trans = daily.ice
del.index=array(NA)
ind.ct=1
daily.ice.Trans$V1=daily.ice.Trans$V1-100
for (i in 1:length(daily.ice.Trans$V1)){
  if (daily.ice.Trans$V2[i] >= 6 & daily.ice.Trans$V2[i] <= 11){
    del.index[ind.ct]=i
    ind.ct=ind.ct+1
  }
}
daily.ice.Trans=daily.ice.Trans[-del.index,]
rownames(daily.ice.Trans)<-seq(1,length(daily.ice.Trans$V1),1)
daily.ice.Trans<-daily.ice.Trans[,c(-2,-3)]
daily.ice.Trans$V6=array(NA)												## create a new column for 10day average
colnames(daily.ice.Trans)<-c("day_number","year","ice","avg10day_ice")	## the first date of solid ice
date_num=array(NA)
avg10day.max=array(NA)												## max of 10day average in each year
month1 <- c(12,1,2,3,4,5)

for (i in year_start:year_end){ #TU
  yr.index=array(NA)
  count=1
  for (j in 1:length(daily.ice.Trans$day_number)){
    if(daily.ice.Trans$year[j]==i){
      yr.index[count]=j
      count=count+1
    }
  }
  for (k in 1:(length(yr.index)-9)){
    daily.ice.Trans$avg10day_ice[yr.index[1]+k+8]=(sum((daily.ice.Trans$ice)[(yr.index[1]-1+k):(yr.index[1]+8+k)]))/10 #Calculation of Average
  }
  for (l in 10:length(yr.index)){
    if(daily.ice.Trans$avg10day_ice[yr.index[l]]>=90){
      date_num[i-year_start+1]=daily.ice.Trans$day_number[yr.index[l]]
      break
    }
  }
  avg10day.max[i-year_start+1]=max(na.omit(daily.ice.Trans$avg10day_ice[yr.index[1]:yr.index[k+9]]))
  x=i
  
}
if (avg10day.max[length(avg10day.max)]<90){
  date_num[length(avg10day.max)] = NA
} 

#Taking Ice Cover daily data from Dec-May 1973-Present
#Making 10-day ice averages from that current day and storing every year's greater than 90% cover in date_num(Used in Correlations)
#Every Year's Max Cover is in avg10day.max


#######PLOT: daily ice cover and 10-day average, paneled for each year########

if (exportplots) {
  plotname=paste0(plotdir,"daily_ice_cover_fitted.pdf") #Comment to SIP
  pdf(file=plotname, height = 6, width = 9, paper = "special") # Comment to SIP
  

par(mfrow = c(5, 10))
par(oma = c(6,5,1,4))
par(mar = c(0,0,0,0))

#plot.new();	plot.new()

for (i in year_start:year_end){ #TU
  yr.index=array(NA)
  count=1
  for (j in 1:length(daily.ice.Trans$day_number)){
    if(daily.ice.Trans$year[j]==i){
      yr.index[count]=j
      count=count+1
    }
  }
  plot(daily.ice.Trans$ice[yr.index], type = "l",xlim = c(0, 210),ylim = c(0, 120), axes=FALSE, xlab=''); box()
  lines(daily.ice.Trans$avg10day_ice[yr.index], col = "red")
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

# plot.new();plot.new();plot.new();plot.new();plot.new();plot.new() #1 too many plot.news()??
# par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE)
# plot(0, 0, type = "n", bty = "n", xaxt = "n", yaxt = "n")
# legend(x = "bottom",legend=c(	"Daily ice cover",
# "10-day average ice cover",
# "90% ice cover (reference)"),
# col=c("black","red","blue"),lty=1,pch=NA,xpd = TRUE, horiz = TRUE, inset = c(0,0), bty = "n",cex=1.2)

if (exportplots) {
  dev.off() #Comment to SIP
  
}
}
###################PLOT: date of seasonal ice onset###############################################
### NOTE: This figure is unused in the 2022 manuscript
if (exportplots) {
  plotname=paste0(plotdir,"Date of Seasonal Ice Onset.pdf") #Comment to SIP 
  pdf(file=plotname, height = 4, width = 6.5, paper = "special") #Comment to SIP
  
par(mar = c(3,4,1,1))
plot(date_num, type = "n", axes = FALSE, ylim = c(20, 105), xlim = c(1,year_len), ylab = '', xlab = ''); box()
points(date_num,type='p',pch=20,cex=0.65, col = "black")
points(date_num,type='l')
#points(Yzeroice, type='p', pch=20, col=ColZero, cex=1)
month <- c(12,1,2,3,4)
axis(2, at = c(1,32,63,91, 122), labels = month.abb[month])
axis(1, at = seq(3, 48, 5), labels = seq(1975,2020, 5), tck = -0.03)
axis(1, at = seq(1,year_len), labels = FALSE, tck = -0.009)
mtext("Ice onset date",2,line=3, cex=1.2)
#legend(x = "topleft",legend=c(	"Years with less than 90% Ice Cover",
#                              "Date of 90% Ice Cover Onset"),col=c("red","black"),pch=c(20, 20), bty = 'n')
if (exportplots) {
dev.off()
}
}
########Fix avg10day ice 0 and 1 problem so that can be used in gamlss model by formula (y*(n-1)+0.5)####

avg10day.max=avg10day.max*0.01

#n=length(avg10day.max)
#avg10day.max=(avg10day.max*(n-1)+0.5)/n
#BUILDING TELECONNECTIONS DATA SET --------
#######. SOI Data########

url <- "https://www.esrl.noaa.gov/psd/data/correlation/soi.data" 
SOI_data_raw = scan(url, what = "double()", sep = "")
SOI_data_raw <- as.numeric(SOI_data_raw)

length_SOI_data = length(SOI_data_raw)
sorted_SOI_data = array(data = NA, dim = c(SOI_data_raw[2] - SOI_data_raw[1] + 1, 12))
list_SOI_data = array(data = NA, dim = c((SOI_data_raw[2] - 1972) * 5))
list_counter_1 = 1

for (i in 3:length_SOI_data) {
  for (j in SOI_data_raw[1]:SOI_data_raw[2]) {
    if (!is.na(SOI_data_raw[i]) && SOI_data_raw[i] == j) {
      for (k in 1:12) {
        sorted_SOI_data[j - SOI_data_raw[1] + 1,k] = SOI_data_raw[i + k]
      }
    }
  }
}

sorted_SOI_data = sorted_SOI_data[-(1:(1972 - SOI_data_raw[1])),-(1:7)] #cutting extraneaous data

for (i in 1:length(sorted_SOI_data[,1])) {
  for (j in 1:length(sorted_SOI_data[1,])) {
    list_SOI_data[list_counter_1] = sorted_SOI_data[i,j]
    list_counter_1 = list_counter_1 + 1
  }
}

###########. NAO Data ########

url <- "https://www.esrl.noaa.gov/psd/data/correlation/nao.data" 
NAO_data_raw = scan(url, what = "double()", sep = "")
NAO_data_raw <- as.numeric(NAO_data_raw)

length_NAO_data = length(NAO_data_raw)
sorted_NAO_data = array(data = NA, dim = c(NAO_data_raw[2] - NAO_data_raw[1] + 1, 12))
list_NAO_data = array(data = NA, dim = c((NAO_data_raw[2] - 1972) * 5))
list_counter_1 = 1

for (i in 3:length_NAO_data) {
  for (j in NAO_data_raw[1]:NAO_data_raw[2]) {
    if (!is.na(NAO_data_raw[i]) && NAO_data_raw[i] == j) {
      for (k in 1:12) {
        sorted_NAO_data[j - NAO_data_raw[1] + 1,k] = NAO_data_raw[i + k]
      }
    }
  }
}

sorted_NAO_data = sorted_NAO_data[-(1:(1972 - NAO_data_raw[1])),-(1:7)] #cutting extraneaous data

for (i in 1:length(sorted_NAO_data[,1])) {
  for (j in 1:length(sorted_NAO_data[1,])) {
    list_NAO_data[list_counter_1] = sorted_NAO_data[i,j]
    list_counter_1 = list_counter_1 + 1
  }
}

#######. EL NINO Data ##########

url <- "https://www.esrl.noaa.gov/psd/gcos_wgsp/Timeseries/Data/nino34.long.anom.data" 

NINO_data_raw = scan(url, what = "double()", sep = "")
NINO_data_raw <- as.numeric(NINO_data_raw)

length_NINO_data = length(NINO_data_raw)
sorted_NINO_data = array(data = NA, dim = c(NINO_data_raw[2] - NINO_data_raw[1] + 1, 12))
list_NINO_data = array(data = NA, dim = c((NINO_data_raw[2] - 1972) * 5))
list_counter_1 = 1

for (i in 3:length_NINO_data) {
  for (j in NINO_data_raw[1]:NINO_data_raw[2]) {
    if (!is.na(NINO_data_raw[i]) &&NINO_data_raw[i] == j) {
      for (k in 1:12) {
        sorted_NINO_data[j - NINO_data_raw[1] + 1,k] = NINO_data_raw[i + k]
      }
    }
  }
}

sorted_NINO_data = sorted_NINO_data[-(1:(1972 - NINO_data_raw[1])),-(1:7)] #cutting extraneaous data

for (i in 1:length(sorted_NINO_data[,1])) {
  for (j in 1:length(sorted_NINO_data[1,])) {
    list_NINO_data[list_counter_1] = sorted_NINO_data[i,j]
    list_counter_1 = list_counter_1 + 1
  }
}

##########. AO Data #########
url <- "https://www.cpc.ncep.noaa.gov/products/precip/CWlink/daily_ao_index/monthly.ao.index.b50.current.ascii" 
ao_ASCII = scan(url, what = "double()", sep = "")
other_list_AO = array(NA)
counter=1
for (i in seq(1,length(ao_ASCII),3)) {
  
  if (ao_ASCII[i]>1971 && as.numeric(ao_ASCII[i+1])>7 && as.numeric(ao_ASCII[i+1])<13){
    other_list_AO[counter] = as.numeric(ao_ASCII[i+2])
    counter=counter+1}
}
list_AO_data = other_list_AO

#########. PDO Data #########


url <- "https://www.esrl.noaa.gov/psd/gcos_wgsp/Timeseries/Data/pdo.long.data" 
PDO_data_raw = scan(url, what = "double()", sep = "")
PDO_data_raw <- as.numeric(PDO_data_raw)

length_PDO_data = length(PDO_data_raw)
sorted_PDO_data = array(data = NA, dim = c(PDO_data_raw[2] - PDO_data_raw[1] + 1, 12))
list_PDO_data = array(data = NA, dim = c((PDO_data_raw[2] - 1972) * 5))
list_counter_1 = 1

for (i in 3:length_PDO_data) {
  for (j in PDO_data_raw[1]:PDO_data_raw[2]) {
    if (!is.na(PDO_data_raw[i]) && PDO_data_raw[i] == j) {
      for (k in 1:12) {
        sorted_PDO_data[j - PDO_data_raw[1] + 1,k] = PDO_data_raw[i + k]
      }
    }
  }
}

sorted_PDO_data = sorted_PDO_data[-(1:(1972 - PDO_data_raw[1])),-(1:7)] #cutting extraneaous data

for (i in 1:length(sorted_PDO_data[,1])) {
  for (j in 1:length(sorted_PDO_data[1,])) {
    list_PDO_data[list_counter_1] = sorted_PDO_data[i,j]
    list_counter_1 = list_counter_1 + 1
  }
}

########. PNA Data #########

url <- "https://www.esrl.noaa.gov/psd/data/correlation/pna.data" 
PNA_data_raw = scan(url, what = "double()", sep = "")
PNA_data_raw <- as.numeric(PNA_data_raw)

length_PNA_data = length(PNA_data_raw)
sorted_PNA_data = array(data = NA, dim = c(PNA_data_raw[2] - PNA_data_raw[1] + 1, 12))
list_PNA_data = array(data = NA, dim = c((PNA_data_raw[2] - 1972) * 5))
list_counter_1 = 1

for (i in 3:length_PNA_data) {
  for (j in PNA_data_raw[1]:PNA_data_raw[2]) {
    if (!is.na(PNA_data_raw[i]) && PNA_data_raw[i] == j) {
      for (k in 1:12) {
        sorted_PNA_data[j - PNA_data_raw[1] + 1,k] = PNA_data_raw[i + k]
      }
    }
  }
}

sorted_PNA_data = sorted_PNA_data[-(1:(1972 - PNA_data_raw[1])),-(1:7)] #cutting extraneaous data

for (i in 1:length(sorted_PNA_data[,1])) {
  for (j in 1:length(sorted_PNA_data[1,])) {
    list_PNA_data[list_counter_1] = sorted_PNA_data[i,j]
    list_counter_1 = list_counter_1 + 1
  }
}

#######. Air Temp For Duluth #######

airTmp_raw = read.csv('SpreadsheetData/DuluthAirTemp1972_2021.csv')
airTmp_raw = airTmp_raw[,-1]
list_airTmp = array(NA)
counter = 1
for (i in 1:length(airTmp_raw[,1])) {
  for (j in 1:length(airTmp_raw[1,])) {
    list_airTmp[counter] = airTmp_raw[i,j]
    counter = counter + 1
  }
}
#######. Water temperature, Lake Superior ########
water_temp_raw = read.csv("SpreadsheetData//WaterTempModStitch.csv")
water_temp_raw = water_temp_raw[,-1]
water_temp_raw = water_temp_raw[,-6]
water_temp = array(NA)
counter = 1
for (i in 1:length(water_temp_raw[,1])) {
  for (j in 1:length(water_temp_raw[1,])) {
    water_temp[counter] = water_temp_raw[i,j]
    counter = counter + 1
  }
}
#######. AWSSI ########
url = "https://mrcc.purdue.edu/AWSSI/RAWSSI/rawssi.DLHthr.csv"
awssi_very_raw = read.csv(url,sep="\t")
awssi_very_raw  <- strsplit(as.character(awssi_very_raw $DLHthr.......T..MN...Duluth), ',')
awssi_raw=array(NA)
counter=1
for (i in 2:length(awssi_very_raw)) {
  if (substr(awssi_very_raw[i][[1]][1],0,4)>1970) { #Reads as the year before, change to 1971 to do the year of
    for (r in 1:5) { #Repeated 5 times to make managing data more consistent, AWSSI is a one-per-year value
      awssi_raw[counter+r-1]=strtoi(awssi_very_raw[i][[1]][12])
      
    }
    counter = counter+r
  }
} 
awssi=awssi_raw
awssi[246:250] = awssi_raw[245] #Hold up for 2021
#######. CO2 ########
#From Barrow, Alaska
#url = "https://gml.noaa.gov/aftp/data/trace_gases/co2/flask/surface/txt/co2_brw_surface-flask_1_ccgg_month.txt"
#cot_raw <- read.table(url, skip = 71, stringsAsFactors = FALSE)
#index=which(cot_raw$V3>7 & cot_raw$V2>1971)
#cot_raw = cot_raw[index,]
#cot=cot_raw$V4
#######. EP-NP ########
url = "https://psl.noaa.gov/data/correlation/epo.data"
EPO_data_raw = scan(url, what = "double()", sep = "")
EPO_data_raw <- as.numeric(EPO_data_raw)

length_EPO_data = length(EPO_data_raw)
sorted_EPO_data = array(data = NA, dim = c(EPO_data_raw[2] - EPO_data_raw[1] + 1, 12))
list_EPO_data = array(data = NA, dim = c((EPO_data_raw[2] - 1972) * 5))
list_counter_1 = 1

for (i in 3:length_EPO_data) {
  for (j in EPO_data_raw[1]:EPO_data_raw[2]) {
    if (!is.na(EPO_data_raw[i]) && EPO_data_raw[i] == j) {
      for (k in 1:12) {
        sorted_EPO_data[j - EPO_data_raw[1] + 1,k] = EPO_data_raw[i + k]
      }
    }
  }
}

sorted_EPO_data = sorted_EPO_data[-(1:(1972 - EPO_data_raw[1])),-(1:7)] #cutting extraneaous data

for (i in 1:length(sorted_EPO_data[,1])) {
  for (j in 1:length(sorted_EPO_data[1,])) {
    list_EPO_data[list_counter_1] = sorted_EPO_data[i,j]
    list_counter_1 = list_counter_1 + 1
  }
}
#######. TNH ########
tnh_raw = read.csv("SpreadsheetData//ayumi_tnh.csv")
tnh_raw = tnh_raw[,-1]
tnh = array(NA)
counter = 1
for (i in 1:length(tnh_raw[,1])) {
  for (j in 1:length(tnh_raw[1,])) {
    tnh[counter] = tnh_raw[i,j]
    counter = counter + 1
  }
}
#######. FU_OLR ########
OLR_raw = read.csv("SpreadsheetData//FU_OLR.csv")
OLR_raw = OLR_raw[,-1]
OLR = array(NA)
counter = 1
for (i in 1:length(OLR_raw[,1])) {
  for (j in 1:length(OLR_raw[1,])) {
    OLR[counter] = OLR_raw[i,j]
    counter = counter + 1
  }
}
#######. MISHRA_AMO ########
AMO_raw = read.csv("SpreadsheetData//MISHRA_AMO.csv")
AMO_raw = AMO_raw[,-1]
AMO = array(NA)
counter = 1
for (i in 1:length(AMO_raw[,1])) {
  for (j in 1:length(AMO_raw[1,])) {
    AMO[counter] = AMO_raw[i,j]
    counter = counter + 1
  }
}
########. year Data ########
year_column = rep(x = c((year_start-1):year_end), times = 1, each = 5)
#######. Month Data ########
month_column = rep(x = c(8:12), times = length(year_column) / 5, each = 1)

#######. Build Data Table #######
tele_data2 = list(year = year_column, 
                  month = month_column, 
                  ao = list_AO_data,
                  nino3.4 = list_NINO_data,
                  nao = list_NAO_data, 
                  pdo = list_PDO_data,
                  pna = list_PNA_data, 
                  soi = list_SOI_data,
                  waterTmp = water_temp,
                  airTemp = list_airTmp,
                  wsi = awssi,
                  epo = list_EPO_data,
                  tnh = tnh,
                  OLR = OLR,
                  AMO = AMO,
                  time=c(1:255))

for (i in 1:length(tele_data2)) {
  while (length(tele_data2[[i]]) > year_len*5) { #250 years in applicable model
    
    tele_data2[[i]] = tele_data2[[i]][-length(tele_data2[[i]])]
  }
}
tele_data = data.frame(tele_data2,
                       stringsAsFactors = F)

latest_year = tele_data[[1]][length(tele_data[[1]])]
avg10day.max = avg10day.max[1:((latest_year - year_start+1)+1)] #just cutting to match data timeframes
index<-which(tele_data[,2] == 12)
index.mon=c("aug","sep","oct","nov","dec")
# index.names=c("AO",
#               "Nino3.4",
#               "NAO",
#               "PDO",
#               "PNA",
#               "SOI",
#               "WATERTEMP", 
#               "AIRTEMP",
#               "WSI",
#               "EPO",
#               "TNH")
index.names = colnames(tele_data)[3:length(tele_data)]

mylist=list(aug=tele_data[(index-4),],
            sep=tele_data[(index-3),],
            oct=tele_data[(index-2),],
            nov=tele_data[(index-1),],
            dec=tele_data[index,])


tele=cbind(
  "aug"=mylist[[1]][3:(length(mylist[[1]][1,]) )], 
  "sep"=mylist[[2]][3:(length(mylist[[1]][1,]))],
  "oct"=mylist[[3]][3:(length(mylist[[1]][1,]) )],
  "nov"=mylist[[4]][3:(length(mylist[[1]][1,]) )],
  "dec"=mylist[[5]][3:(length(mylist[[1]][1,]))]) 



###################PLOT: teleconnection indices##########################################################
if (exportplots) {
  plotname = paste0(plotdir, "telec_index.pdf", sep = "") #Comment to SIP
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
if (exportplots) {
  dev.off() #Comment to SIP
  
}

###############Assess correlation of teleconnection indices:#####################################################

## NOTE: code below calculates serial and auto correlation among teleconnections (tele_data_c)
#      AND correlation between teleconnections and ice cover (cor_ice_tele);
#     we only use tele_data_c and telpair in our paper
cor_ice_tele = array(NA,dim=c(11,5))
tele_data_c <- tele_data[,-1:-2] 
monthnames=c("aug","sep","oct","nov","dec")
telenames=colnames(tele_data)[3:length(tele_data)]
for(i in 1:10){
  telepair<-tele_data_c[,i]
  telepair<-data.frame(matrix(unlist(t(telepair)),byrow=T,year_len,5))
  colnames(telepair)<-paste(monthnames,".",telenames[i], sep = "")
  tryCatch({
    for(j in 1:5)	{
      
      cor_ice_tele[i,j]<-cor(date_num,telepair[,j],use='pairwise')
    }
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})

  print(cor_ice_tele)
  print(i)
}
colnames(cor_ice_tele)<-c("aug","sep","oct","nov","dec")
#rownames(cor_ice_tele)<-colnames(tele_data)[3:length(tele_data)]
cor_ice_tele<-t(cor_ice_tele)



## PLOT: teleconnection correlations-----
# 
# 
# for(i in 1:5){
# mi<-seq(i,215,5)
# monthpair<-tele_data_c[mi,]
# plotname = paste(plotdir,"month_",monthnames[i], ".pdf", sep = "")
# colnames(monthpair)<-paste(monthnames[i],".",colnames(monthpair), sep = "")
# pdf(file=plotname)
# par(mfrow = c(5,6))
# par(oma = c(4,4.5,4,4))
# par(mar = c(0.5,0,0.5,0))
# print(ggpairs(monthpair))
# dev.off()
# }
# 
# for(i in 1:length(colnames(tele_data_c))){
# telepair<-tele_data_c[,i]
# telepair<-data.frame(matrix(unlist(t(telepair)),byrow=T,year_len,5))
# colnames(telepair)<-paste(monthnames,".",telenames[i], sep = "")
# plotname = paste(plotdir,"tele_",telenames[i], ".pdf", sep = "")
# pdf(file=plotname)
# par(mfrow = c(5,6))
# par(oma = c(4,4.5,4,4))
# par(mar = c(0.5,0,0.5,0))
# print(ggpairs(telepair))
# dev.off()
# }

#Only Aug AMO, Aug, Nov, Dec OLR
nino3.4 = which(colnames(tele)=="aug.nino3.4")
aug.AMO = which(colnames(tele)=="aug.AMO")
aug.OLR = which(colnames(tele)=="aug.OLR")
nov.OLR = which(colnames(tele)=="nov.OLR")
dec.OLR = which(colnames(tele)=="dec.OLR")
pdo = which(colnames(tele)=="aug.pdo")
waterTmp= which(colnames(tele)=="aug.waterTmp")
WSI = which(colnames(tele)=="aug.wsi")
aug.NAO=which(colnames(tele)=="aug.nao")
sep.NAO=which(colnames(tele)=="sep.nao")
dec.TNH = which(colnames(tele)=="dec.tnh")
seqEPO<-which(endsWith(colnames(tele),".epo")==TRUE & colnames(tele)!="dec.epo")
seqAO<-which(endsWith(colnames(tele),".ao")==TRUE)
seqPNA<-which(endsWith(colnames(tele),".pna")==TRUE)
seqAirTmp<-which(endsWith(colnames(tele),".airTemp")==TRUE)
time = which(colnames(tele)=="aug.time")

tele = cbind(tele[seqAO],tele[seqPNA], tele[seqAirTmp],tele[nino3.4],tele[pdo], tele[waterTmp], tele[aug.NAO], tele[sep.NAO], tele[WSI],tele[dec.TNH],tele[seqEPO],tele[aug.AMO],tele[aug.OLR],tele[nov.OLR],tele[dec.OLR])
telecolnames <-names(tele)

# include single term
teleall = cbind(tele)	# [use this only for indices; not used],c(rep(1,24),rep(0,19)))
names(teleall) = c(telecolnames)

if (nrow(teleall)>length(date_num)) #if teleconnection data has more years than ice data, this bit erases the extra years of teleconnection data
{
  x=0
  for(i in nrow(teleall):length(date_num)+1)
  {
    teleall = teleall[-i,] 
    x=x+1
  }
  print(paste0(x,  " years were taken off the teleconnection index"))
}


###########################################################
###########################################################
######  COX MODEL DEVELOPMENT #############################
###########################################################
###########################################################

## build object for survival model
k=which(is.na(date_num))
## censoring status 0=censored, 1=solid
status=array(NA)
status[1:year_len]=1
status[k]=0
date_num_s=date_num
date_num_s[k]=280
survobj<-Surv(date_num_s, status)

#############. Calibration: Cox model for full time period###################################################################################

## First, use stepwise automated...9 explanatory variables

coxfit1 <- coxph(survobj~.,teleall); summary(coxfit1)
cox.stepfit = step(coxfit1)
summary(cox.stepfit)

## Second, use manual selection automated...CI 0.79, 2 explanatory variables

cox.data_a = teleall[summary(coxfit1)$coefficients[,5]<=0.05]

coxfit2 <- coxph(survobj~.,cox.data_a); 	summary(coxfit2)
cox.data_man = cox.data_a[summary(coxfit2)$coefficients[,5]<=0.05]
cox.manual <- coxph(survobj~.,cox.data_man); 	
summary(cox.manual)

## Third, use values from the literature... CI 0.83, 4-5 explanatory variables
	
temp_cols = c("dec.airTemp","sep.epo","aug.AMO","dec.OLR", "nov.ao")
#cox.data_b = tele[temp_cols]  # Aug.AMO not significant

#temp_cols = c("dec.airTemp","sep.epo","dec.OLR", "nov.ao")
cox.data_b = tele[temp_cols] 

coxfit3 <- coxph(survobj~., cox.data_b, x=TRUE); 	
summary(coxfit3)

######################################################################################
## Proceed using the model with values from the lit................
######################################################################################

pr_pr_cox = predictSurvProb(coxfit3,cox.data_b,times=c(280))

date_cox=array(NA)	# days until solid ice happen
for(i in 1:year_len){
  date_cox[i]<-quantile(survfit(coxfit3, newdata = cox.data_b[i,]),probs = 0.1, conf.int = FALSE)
}

######################################################################################
### Validation (split periods) and leave-one-out
######################################################################################

survobj1 = survobj[1:24]
survobj2 = survobj[25:year_len]

coxfit_cpt_b <- coxph(survobj1~.,cox.data_b[1:24,],x=TRUE)
summary(coxfit_cpt_b)

coxfit_cpt_a <- coxph(survobj2~.,data.frame(cox.data_b[25:year_len,]),x=TRUE)#, iter.max = 30)#,x=TRUE)
summary(coxfit_cpt_a)

pr_pr_cox_cpt = array(NA)
pr_pr_cox_cpt[1:24]=predictSurvProb(coxfit_cpt_b,cox.data_b[1:24,],times=c(280))
pr_pr_cox_cpt[25:year_len]=predictSurvProb(coxfit_cpt_a,cox.data_b[25:year_len,],times=c(280))
date_cox_cpt=array(NA)
for(i in 1:24){
  date_cox_cpt[i]<-quantile(survfit(coxfit_cpt_b, newdata=cox.data_b[i,]),probs = 0.1, conf.int = FALSE)
}
for(i in 25:year_len){
  date_cox_cpt[i]<-quantile(survfit(coxfit_cpt_a, newdata=cox.data_b[i,]),probs = 0.1, conf.int = FALSE)
}

#############. Leave one-out cross-validation for Cox model for entire period###################################################################################

pr_pr_cox_cv=array(NA)
date_cox_cv=array(NA)

for(i in 1:year_len){
  survobj_cv <- survobj[-i]
  cox.data_b.cv <- cox.data_b[-i,]
  coxfit_cv <- coxph(survobj_cv~.,cox.data_b.cv, x=TRUE)
  pr_pr_cox_cv[i] = predictSurvProb(coxfit_cv, cox.data_b[i,],times=c(280))
  date_cox_cv[i] <- quantile(survfit(coxfit_cv, cox.data_b[i,]),probs = 0.1, conf.int = FALSE)
}#43 is '91', code skips it

###################. Cross-validation: Cox model for split periods#############################################################################

pr_pr_cox_cpt_cv=array(NA,dim=year_len)
date_cox_cpt_cv=array(NA,dim=year_len)

for(i in 25:year_len){
  survobj_cpt_cv 		<- survobj[25:year_len][-(i-24)]
  cox.data_b.cpt.cv 	<- cox.data_b[25:year_len,][-(i-24),]
  coxfit_cpt_a_cv 	<- coxph(survobj_cpt_cv~.,cox.data_b.cpt.cv, x=TRUE)
  
  pr_pr_cox_cpt_cv[i] = predictSurvProb(coxfit_cpt_a_cv, cox.data_b[i,],times=c(280))
  date_cox_cpt_cv[i]	<- quantile(survfit(coxfit_cpt_a_cv, cox.data_b[i,]),probs = 0.1, conf.int = FALSE)
}

for(i in 1:24){
  survobj_cpt_cv 		<- survobj[1:24][-i]
  cox.data_b.cpt.cv 	<- cox.data_b[1:24,][-i,]
  coxfit_cpt_b_cv		<- coxph(survobj_cpt_cv~., cox.data_b.cpt.cv, x=TRUE)
  
  pr_pr_cox_cpt_cv[i]	= predictSurvProb(coxfit_cpt_b_cv, cox.data_b[i,],times=c(280))
  date_cox_cpt_cv[i]	<- quantile(survfit(coxfit_cpt_b_cv, cox.data_b[i,]),probs = 0.1, conf.int = FALSE)
}


################################################ Cox model - USING LAST PREDICTED SURIVIVAL PROBABILITY TO PREDICT THE YEARLY CHANCE OF ICE ONSET #############################################

cox_probs_cpt = array(NA)
for (year_number in 1:year_len) {
  
  cox_model_to_use = NULL
  
  if (year_number <(1998-1973)) {
    cox_model_to_use = coxfit_cpt_b
  } else {
    cox_model_to_use = coxfit_cpt_a
  }
  cox_probs_cpt[year_number] = tail(survfit(cox_model_to_use, newdata=teleall[year_number,])$surv,1)
  
}



###################################################
###################################################
###################################################
################# REGRESSION MODELS: Beta #########
###################################################
###################################################
## Yin/Ayumi Model
#cols = c("aug.nao","sep.nao","aug.nino3.4","aug.pna","sep.pna","oct.pna","nov.pna","dec.pna"
#         ,"aug.epo","sep.epo","oct.epo","nov.epo","dec.tnh")
## Just Mishra Model
#cols = c("aug.airTemp","sep.airTemp","oct.airTemp","nov.airTemp","dec.airTemp","aug.AMO","aug.nino3.4","aug.pdo")
## Just FU Model ?

###################################################

# Use stepwise regression; more efficient than manual using "betareg" (use "betareg" at end)
# (see snippet at end of this file for unused method using stepGAIC)

###################################################

### Set up 'gamlss' model object using all possible explanatory variables (teleall)

beta.gam	<-gamlss(	avg10day.max~., data=teleall,	
                   family = BE, trace = FALSE, 			
                   method = mixed(10,1000))	

## First, automated stepwise regression...results in 15 variables, impractical

beta.step = step(beta.gam, direction = "both")  
summary(beta.step)		

## Second, manual stepwise using betareg

beta.man.1 = betareg(avg10day.max~.,data=teleall)
summary(beta.man.1)

beta.data_a = teleall[,summary(beta.man.1)$coefficients$mean[-1,4]<=0.05]
beta.man.2 = betareg(avg10day.max~.,data=beta.data_a)
summary(beta.man.2)

beta.data_b = beta.data_a[,summary(beta.man.2)$coefficients$mean[-1,4]<=0.05]
beta.man.3 = betareg(avg10day.max~.,data=beta.data_b)
summary(beta.man.3)

beta.data_c = beta.data_b[,summary(beta.man.3)$coefficients$mean[-1,4]<=0.05]
beta.man.4 = betareg(avg10day.max~.,data=beta.data_c)
summary(beta.man.4)

beta.data_d = beta.data_c[,summary(beta.man.4)$coefficients$mean[-1,4]<=0.05]
beta.man.5 = betareg(avg10day.max~.,data=beta.data_d)
summary(beta.man.5)

## Third, combination of model selection and expert opinion

temp_cols.manual = c("sep.airTemp","aug.waterTmp","nov.epo")  			# Results of manual regression

temp_cols.exp = c("dec.airTemp","nov.ao","aug.AMO","dec.OLR","sep.epo") ## Expert opinion variables

beta.expert = betareg(avg10day.max~.,data=tele[temp_cols.exp])
summary(beta.expert)

beta.expert = betareg(avg10day.max~.,data=tele[temp_cols.manual])
summary(beta.expert)

###############################################################

#mod.beta.max = beta.man.5  # Enter which model to plot and evaluate here....
mod.beta.max = beta.expert
# ## betareg function, unfortunately does not (!) have uncertainty bounds, 
# ## so we calculate them manually through mu, phi (alpha, beta)

##
library(HDInterval)

mu 		<- predict(mod.beta.max)
phi 	= mod.beta.max$coefficients$precision
alpha 	= mu*phi
beta	= (1-mu)*phi
#up_bound	= qbeta(c(0.975),alpha,beta)	# This is the quantile based method
#lw_bound	= qbeta(c(0.025),alpha,beta)
up.bounds = lw.bounds = lw.iqr = up.iqr = NULL							# Use HPD intervals instead	
for(i in 1:length(alpha)){
lw.bounds[i] = hdi(qbeta,shape1 = alpha[i], shape2 = beta[i])[1]
up.bounds[i] = hdi(qbeta,shape1 = alpha[i], shape2 = beta[i])[2]
lw.iqr[i] = hdi(qbeta,shape1 = alpha[i], shape2 = beta[i], credMass = 0.5)[1]
up.iqr[i] = hdi(qbeta,shape1 = alpha[i], shape2 = beta[i], credMass = 0.5)[2]
}

cbind(lw_bound, up_bound, lw.bounds, up.bounds)

## To find probability of ice cover exceeding 90%, we use pbeta
pr_pr_beta  = pbeta(0.9,alpha,beta)						# predicted probability of NO safe ice cover in each season

############# PLOT: beta model maximum of 10-day average ice cover#########################################################

if (exportplots) {
  plotname=paste0(plotdir,"Beta model Seasonal Max Ice cover.pdf") #Comment for SIP
  pdf(file=plotname, height = 4.5, width = 8, paper = "special") #Comment for SIP
  
}
plot(avg10day.max, type = "n", axes = FALSE, ylim = c(0, 100), xlim = c(1, year_len),xlab="Ice year",
     ylab="Maximum of 10-day average Ice cover %"); box()
axis(1,at = seq(1, 48, 5), labels = seq(1973,2020, 5))
axis(2)
for(i in 1:year_len){
 # segments(i,lw_bound[i]*100,x1=i,y1=up_bound[i]*100, col="dimgrey")   # based on quantiles 
 segments(i,lw.bounds[i]*100,x1=i,y1=up.bounds[i]*100, col="dimgrey")   # based on HPD region
 segments(i,lw.iqr[i]*100,x1=i,y1=up.iqr[i]*100, lwd = 2.5, col="black")   # based on HPD region
}
points(avg10day.max*100,type='p',pch=20,cex=1.1,col="red")

x0=c(1,year_len)
y0=c(0.9,0.9)
points(x0,y0*100,type='l',col='blue')
if (exportplots) {
  dev.off() #Comment for SIP
}

######### Beta model with change point#######################################################################################

pr_pr_beta_cpt=array(NA)

mod.beta.max.cpt_b = betareg(avg10day.max[1:24]~.,			data=beta.data_d[1:24,])
mod.beta.max.cpt_a = betareg(avg10day.max[25:year_len]~.,	data=beta.data_d[25:year_len,])     # Have to go back one year from year 24 for positive definite matrix
summary(mod.beta.max.cpt_b); summary(mod.beta.max.cpt_a)

## Didn't yield any better results....
# step.beta.max.cpt_b = gamlss(avg10day.max[1:24]~.,data=teleall[1:24,],
						# family = BE, trace = FALSE, 			## Use LOTS of iterations
						# method = mixed(10,1000))
# step.beta.max.cpt_a = gamlss(avg10day.max[23:year_len]~.,data=teleall[23:year_len,],
						# family = BE, trace = FALSE, 			## Use LOTS of iterations
						# method = mixed(10,1000))
# summary(step(step.beta.max.cpt_b)); summary(step(step.beta.max.cpt_a))



## before 1998
pred_value_cpt_b <- predict(mod.beta.max.cpt_b)
mu_cpt_b	= pred_value_cpt_b
phi_cpt_b	= mod.beta.max.cpt_b$coefficients$precision
alpha_cpt_b	= mu_cpt_b*phi_cpt_b
beta_cpt_b	= (1-mu_cpt_b)*phi_cpt_b
pr_pr_beta_cpt[1:24] = unlist(pbeta(0.9,alpha_cpt_b,beta_cpt_b))
## after 1998
pred_value_cpt_a <- predict(mod.beta.max.cpt_a)
mu_cpt_a	= pred_value_cpt_a
phi_cpt_a	= mod.beta.max.cpt_a$coefficients$precision
alpha_cpt_a	= mu_cpt_a*phi_cpt_a
beta_cpt_a	= (1-mu_cpt_a)*phi_cpt_a
pr_pr_beta_cpt[23:year_len] = unlist(pbeta(0.9,alpha_cpt_a,beta_cpt_a))

#######################. Beta model: cross-validation#########################################################################

# cross validation for mode of whole time period
pr_pr_beta_cv = array(NA)
ndb_cv = as.data.frame(cbind(teleall[,c(5,7, 8,12, 13, 14,15,18, 21)]))


for(i in 1:year_len)	{
  mod.beta.max.cv = betareg(avg10day.max[-i]~., data = ndb_cv[-i,])
  mu_cv <- predict(mod.beta.max.cv, newdata=ndb_cv[i,])
  phi_cv 		= mod.beta.max.cv$coefficients$precision
  alpha_cv 	= mu_cv*phi_cv
  beta_cv 	= (1-mu_cv)*phi_cv
  pr_pr_beta_cv[i] = unlist(pbeta(0.9,alpha_cv,beta_cv))
}

# cross validation for change point model
pr_pr_beta_cpt_cv = array(NA,dim=year_len)

### post-1998 model

for(i in 22:year_len)	{
  mod.beta.max.cpt_cv = betareg(avg10day.max[22:year_len][-(i-21)]~., data = ndb_cv[22:year_len,][-(i-21),])
  mu_cpt_cv <- predict(mod.beta.max.cpt_cv, newdata = ndb_cv[22:year_len,][i-21,])
  phi_cpt_cv = mod.beta.max.cpt_cv$coefficients$precision
  alpha_cpt_cv=mu_cpt_cv*phi_cpt_cv
  beta_cpt_cv=(1-mu_cpt_cv)*phi_cpt_cv
  pr_pr_beta_cpt_cv[i]=unlist(pbeta(0.9,alpha_cpt_cv,beta_cpt_cv))
}

# cross validation for beta before 1998

for(i in 1:24)	{
  mod.beta.max.cpt_cv = betareg(avg10day.max[1:24][-i]~.,data = ndb_cv[1:24,][-i,])
  mu_cpt_cv <- predict(mod.beta.max.cpt_cv,newdata = ndb_cv[1:24,][i,])
  phi_cpt_cv = mod.beta.max.cpt_cv$coefficients$precision
  alpha_cpt_cv = mu_cpt_cv*phi_cpt_cv
  beta_cpt_cv = (1-mu_cpt_cv)*phi_cpt_cv
  pr_pr_beta_cpt_cv[i] = unlist(pbeta(0.9,alpha_cpt_cv,beta_cpt_cv))
}


#############################################################################
## Plot summarizing evolution of cofficients during different periods
#############################################################################

#pdf(file = "param_summ.pdf", height = 2.75, width = 6.75, paper = "special")

exportplots = TRUE

if (exportplots) {
  plotname=paste0(plotdir,"param_summ.pdf") #Comment for SIP
  pdf(file=plotname, height = 2.75, width = 6.75, paper = "special") #Comment for SIP
  
}


par(mfcol=c(1,2))
par(mar = c(2.5, 0.5, 0.2, 0))
par(oma = c(0,6.2,0,6.2))
plot(x = c(-1.8,1.8), y = c(0.5,4.5), type = "n", ylim = c(4.5,0.5),
	axes = F, xlab = "", ylab = ""); box(); axis(1)
	axis(2, at = seq(1,4), 
			labels = c(expression("T"[a]*" (Dec)"), "EP-NP (Sep)", "OLR (Dec)", "AO (Nov)"),
			las = 1)
			
abline(v = 0, lty = 3)
for(i in 1:4){
points(x = summary(coxfit3)$coefficients[-3,][i,1], y = i-0.2, pch = 20)
segments(	x0 = log(summary(coxfit3)$conf.int[-3,][i,3]),
			x1 = log(summary(coxfit3)$conf.int[-3,][i,4]),
			y0 = i-0.2, col = 8)
			}
for(i in 1:4){
points(x = summary(coxfit_cpt_b)$coefficients[-3,][i,1], y = i, pch = 20)
segments(	x0 = log(summary(coxfit_cpt_b)$conf.int[-3,][i,3]),
			x1 = log(summary(coxfit_cpt_b)$conf.int[-3,][i,4]),
			y0 = i, col = 8)
			}			

for(i in 1:4){
points(x = summary(coxfit_cpt_a)$coefficients[-3,][i,1], y = i+0.2, pch = 20)
segments(	x0 = log(summary(coxfit_cpt_a)$conf.int[-3,][i,3]),
			x1 = log(summary(coxfit_cpt_a)$conf.int[-3,][i,4]),
			y0 = i+0.2, col = 8)
			}	

plot(x = c(-0.8,0.8), y = c(0.5,4.5), type = "n", ylim = c(4.5,0.5),
	axes = F, xlab = "", ylab = ""); box(); axis(1)
	axis(4, at = seq(1,3), 
			labels = c(expression("T"[a]*" (Sep)"), expression("T"[w]*" (Aug)"), "EP-NP (Nov)"),
			las = 1)
abline(v = 0, lty = 3)

for(i in 1:3){
points(x = mod.beta.max$coeff$mean[i+1], y = i-0.2, pch = 20)	
segments(	x0 = confint(mod.beta.max)[i+1,1],
			x1 = confint(mod.beta.max)[i+1,2],
			y0 = i-0.2, col = 8)
			}
			
for(i in 1:3){
points(x = mod.beta.max.cpt_b$coeff$mean[i+1], y = i, pch = 20)
segments(	x0 = confint(mod.beta.max.cpt_b)[i+1,1],
			x1 = confint(mod.beta.max.cpt_b)[i+1,2],
			y0 = i, col = 8)
			}			

for(i in 1:3){
points(x = mod.beta.max.cpt_a$coeff$mean[i+1], y = i+0.2, pch = 20)
segments(	x0 = confint(mod.beta.max.cpt_a)[i+1,1],
			x1 = confint(mod.beta.max.cpt_a)[i+1,2],
			y0 = i+0.2, col = 8)
			}	
if (exportplots) {
  dev.off() #Comment for SIP
}



################# PLOT Cox result of happeness vs observation and beta ######
#############################################################################
## Note, this plot is based on the full model, and therefore we might want to consider
## putting into the SI only because it doesn't reflect the "best" model for each time period
#############################################################################



if(exportplots) {
  plotname=paste0(plotdir,"Yearly_Cox_Beta_Obs.pdf") #Comment for SIP
  pdf(file=plotname, height = 6, width = 9, paper = "special") #Comment for SIP
  
}
par(mfrow = c(5,10))
par(oma = c(8,5,1,4))
par(mar = c(0,0,0,0))
#plot.new(); box(); plot.new(); box()
for(i in 1:year_len)	{
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

if (exportplots) {
  dev.off() #Comment for SIP
  
}





#########. barplot settings #######################################################################################

dev.new()
df=array(0,dim=year_len)
df[which(is.na(date_num))]=1
df.bar <- barplot(df)
dev.off()

dev.new()
dfd=array(0,dim=year_len)
dfd[which(is.na(date_num))]=180
dfd.bar <- barplot(dfd)
dev.off()


########PLOT cox model and beta model validation########################################################################################


if (exportplots) {
  plotname=paste0(plotdir,"2_var_validation_stepwise.pdf") #Comment for SIP
  pdf(file=plotname, width = 7.5, height = 5, paper = "special") #Comment for SIP
  
}

betacpt=array(NA)
betacptcv=array(NA)
betanorm=array(NA)
betanormcv=array(NA)
for (i in 1:length(pr_pr_beta))
{
  betacpt[i] = 1-pr_pr_beta_cpt[i]
  betacptcv[i] = 1-pr_pr_beta_cpt_cv[i]
  betanorm[i] = 1-pr_pr_beta[i]
  betanormcv[i] = 1-pr_pr_beta_cv[i]
}
par(mfrow = c(2,2))
par(oma = c(3,5,3,4))
par(mar = c(0,0,0,0))
barplot(dfd,ylim=c(18,100),axes=FALSE,border=NA)
points(dfd.bar,date_num,type='p',pch=20,cex=1.1,col="black")
points(dfd.bar,date_cox,type='p',pch=20,cex=0.6,col="red")
points(dfd.bar,date_cox_cv,type='p',pch=1,cex=1,col="red")
box()
axis(2, at = c(1,32,63,91, 122,152), labels = month.abb[month1])
axis(3,at=df.bar[seq(3,50,5)],labels=seq(1975,2020,5))

mtext("Onset of ice cover", side = 2, line = 3.75)
mtext("(Cox model)", 2,line= 2.25)


barplot(dfd,ylim=c(18,100),axes=FALSE,border=NA, ylab = 'ice onset date')
points(dfd.bar,date_num,type='p',pch=20,cex=1.1,col="black")
points(dfd.bar,date_cox_cpt,type='p',pch=20,cex=0.6,col="red")
points(dfd.bar,date_cox_cpt_cv,type='p',pch=1,cex=1,col="red")
axis(3, labels = FALSE)
axis(4, at = c(1,32,63,91, 122,152), labels = FALSE)
box()

barplot(df,ylim=c(-0.05,1.10),axes=FALSE,border=NA)
points(x = df.bar,y=betanorm,type='p',pch=20,cex=0.6,col="red")
points(x = df.bar,y=betanormcv,type='p',pch=1,cex=1,col="red")
box()
axis(2, labels = FALSE)
axis(1,at=df.bar[seq(3,50,5)],labels=FALSE)
mtext("Probabilty of ice cover", 2,line= 3.75)
mtext("(beta model)", 2,line= 2.25)
barplot(df,ylim=c(-0.05,1.10),axes=FALSE,border=NA, ylab = 'probability of ice absence for beta')
points(x = df.bar,y=betacpt,type='p',pch=20,cex=0.6,col="red")
points(x = df.bar,y=betacptcv,type='p',pch=1,cex=1,col="red")
box()
axis(4)
axis(1,at=df.bar[seq(3,50,5)],labels=seq(1975,2020,5))

if (exportplots) {
  dev.off() #Comment for SIP
  
}

## df is a flag for no ice

par(mfrow=c(1,2))
hist(betacpt[-(1:25)][!df[-(1:25)]], freq = F)

#lines(density(betacpt[-(1:25)][!df[-(1:25)]]), col = "blue")
#lines(density(betacpt[-(1:25)][!!df[-(1:25)]]), col = "red")
x.bar = mean(betacpt[-(1:25)][!df[-(1:25)]]); x.bar
x.var = var(betacpt[-(1:25)][!df[-(1:25)]]); x.var
a.hat = x.bar*(x.bar*(1-x.bar)/x.var-1); a.hat
b.hat = (1-x.bar)*(x.bar*(1-x.bar)/x.var-1); b.hat
lines(seq(0,1,0.01),dbeta(seq(0,1,0.01),a.hat,b.hat), col = "blue")

x.bar = mean(betacpt[-(1:25)][!!df[-(1:25)]]); x.bar
x.var = var(betacpt[-(1:25)][!!df[-(1:25)]]); x.var
a.hat = x.bar*(x.bar*(1-x.bar)/x.var-1); a.hat
b.hat = (1-x.bar)*(x.bar*(1-x.bar)/x.var-1); b.hat
lines(seq(0,1,0.01),dbeta(seq(0,1,0.01),a.hat,b.hat), col = "red")

#lines(density(betacptcv[-(1:25)][!df[-(1:25)]]), col = "blue", lty = 2)
#lines(density(betacptcv[-(1:25)][!!df[-(1:25)]]), col = "red", lty = 2)
x.bar = mean(betacptcv[-(1:25)][!df[-(1:25)]]); x.bar
x.var = var(betacptcv[-(1:25)][!df[-(1:25)]]); x.var
a.hat = x.bar*(x.bar*(1-x.bar)/x.var-1); a.hat
b.hat = (1-x.bar)*(x.bar*(1-x.bar)/x.var-1); b.hat
lines(seq(0,1,0.01),dbeta(seq(0,1,0.01),a.hat,b.hat), col = "blue", lty = 2)

x.bar = mean(betacptcv[-(1:25)][!!df[-(1:25)]]); x.bar
x.var = var(betacptcv[-(1:25)][!!df[-(1:25)]]); x.var
a.hat = x.bar*(x.bar*(1-x.bar)/x.var-1); a.hat
b.hat = (1-x.bar)*(x.bar*(1-x.bar)/x.var-1); b.hat
lines(seq(0,1,0.01),dbeta(seq(0,1,0.01),a.hat,b.hat), col = "red", lty = 2)



hist(betacpt[-(1:25)][!df[-(1:25)]], freq = F)
#lines(density(betanorm[-(1:25)][!df[-(1:25)]]), col = "blue")
#lines(density(betanorm[-(1:25)][!!df[-(1:25)]]), col = "red")

x.bar = mean(betanorm[-(1:25)][!df[-(1:25)]]); x.bar
x.var = var(betanorm[-(1:25)][!df[-(1:25)]]); x.var
a.hat = x.bar*(x.bar*(1-x.bar)/x.var-1); a.hat
b.hat = (1-x.bar)*(x.bar*(1-x.bar)/x.var-1); b.hat
lines(seq(0,1,0.01),dbeta(seq(0,1,0.01),a.hat,b.hat), col = "blue")

x.bar = mean(betanorm[-(1:25)][!!df[-(1:25)]]); x.bar
x.var = var(betanorm[-(1:25)][!!df[-(1:25)]]); x.var
a.hat = x.bar*(x.bar*(1-x.bar)/x.var-1); a.hat
b.hat = (1-x.bar)*(x.bar*(1-x.bar)/x.var-1); b.hat
lines(seq(0,1,0.01),dbeta(seq(0,1,0.01),a.hat,b.hat), col = "red")

#lines(density(betanormcv[-(1:25)][!df[-(1:25)]]), col = "blue", lty = 2)
#lines(density(betanormcv[-(1:25)][!!df[-(1:25)]]), col = "red", lty = 2)

x.bar = mean(betanormcv[-(1:25)][!df[-(1:25)]]); x.bar
x.var = var(betanormcv[-(1:25)][!df[-(1:25)]]); x.var
a.hat = x.bar*(x.bar*(1-x.bar)/x.var-1); a.hat
b.hat = (1-x.bar)*(x.bar*(1-x.bar)/x.var-1); b.hat
lines(seq(0,1,0.01),dbeta(seq(0,1,0.01),a.hat,b.hat), col = "blue", lty = 2)

x.bar = mean(betanormcv[-(1:25)][!!df[-(1:25)]]); x.bar
x.var = var(betanormcv[-(1:25)][!!df[-(1:25)]]); x.var
a.hat = x.bar*(x.bar*(1-x.bar)/x.var-1); a.hat
b.hat = (1-x.bar)*(x.bar*(1-x.bar)/x.var-1); b.hat
lines(seq(0,1,0.01),dbeta(seq(0,1,0.01),a.hat,b.hat), col = "red", lty = 2)

betacpt[i] = 1-pr_pr_beta_cpt[i]
betacptcv[i] = 1-pr_pr_beta_cpt_cv[i]
betanorm[i] = 1-pr_pr_beta[i]
betanormcv[i] = 1-pr_pr_beta_cv[i]


#######PLOT summary#########################################################################################

new.seg = date_num-date_cox_cpt; new.seg
if(exportplots) {
  plotname=paste0(plotdir,"summary.pdf") #Comment for SIP
  pdf(file=plotname, height = 4, width = 6.5, paper = "special") #Comment for SIP
  
}
par(mar = c(3,4,1,1))
plot(date_num, type = "n", axes = FALSE, ylim = c(20, 105), xlim = c(1,year_len), ylab = '', xlab = ''); box()
for(i in 1:year_len){
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
axis(1, at = seq(1,year_len), labels = FALSE, tck = -0.009)
month <- c(12,1,2,3,4)
axis(2, at = c(1,32,63,91, 122), labels = month.abb[month])

if(exportplots) {
  dev.off() #Comment for SIP
  
}


##########################################################
#PLOT with Model Data----
##########################################################

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
for (i in 1:length(pr_pr_beta))
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

if (exportplots) {
  plotname=paste0(plotdir,"Cox_and_Beta_as_yearly_predictor_mixed_iceonset.pdf") #Comment for SIP
  pdf(file=plotname, height = 8, width = 8.5, paper = "special") #Comment for SIP
  
}
par(mfrow = c(2,1))
par(mar = c(0,0,0,0))
par(oma=c(3,4,1,1))
plot	(date_num, type = "n", axes = FALSE, ylim = c(20, 105), xlim = c(1,year_len), ylab = '', xlab = ''); box()
abline 	(v = which(obsnoice == 20), lwd = 6, col = "darkgrey")
abline 	(v = which(beta_alarm == 18), lwd = 1,col = "blue")
points	(date_num, type='p', pch=20, cex=0.65)
points	(date_num, type='l')
#points	(date_cox_cpt, type='p', pch=21, cex=0.85, col="red")
month <- c(12,1,2,3,4)
axis(2, at = c(1,32,63,91, 122), labels = month.abb[month])
axis(3, at = seq(3, 48, 5), labels = seq(1975,2020, 5), tck = -0.03)
axis(3, at = seq(1,year_len), labels = FALSE, tck = -0.009)
legend(x = "topleft",legend=c(	"Observed ice onset date",
                              # "Simulated ice onset date", 
                               "No observed ice onset",
                               "No simulated ice onset (beta)"),
       col=c("black", "darkgrey", "blue"),
       pch=c(16, 15, 15), bty = 'n', cex=0.98,ncol=1)
	   
	   
plot	(date_num, type = "n", axes = FALSE, ylim = c(20, 105), xlim = c(1,year_len), ylab = '', xlab = ''); box()
abline 	(v = which(obsnoice == 20), lwd = 6, col = "darkgrey")
abline(v = which(cox_probs_cpt_alarm ==TRUE),lwd=1,col="red")
points	(date_num, type='p', pch=20, cex=0.65)
points	(date_num, type='l')
points	(date_cox_cpt, type='p', pch=21, cex=0.85, col="red")
month <- c(12,1,2,3,4)
axis(2, at = c(1,32,63,91, 122), labels = month.abb[month])
axis(1, at = seq(3, 48, 5), labels = seq(1975,2020, 5), tck = -0.03)
axis(1, at = seq(1,year_len), labels = FALSE, tck = -0.009)
mtext("Ice onset date",2,line=3, cex=1.2)
legend(x = "topleft",legend=c(	"Observed ice onset date",
                               "Simulated ice onset date (Cox)", 
                               "No observed ice onset",
                               "No simulated ice onset (Cox)"),
       col=c("black", "red", "darkgrey","red"),
       pch=c(16, 21, 15, 15), bty = 'n', cex=0.98,ncol=1)
if (exportplots) {
  dev.off() #Comment to SIP
  
}











##############################################################################
##############################################################################
##############################################################################
####ROC Curves - Skill Test ####
if (exportplots) {
  plotname=paste0(plotdir,"5_Var_ROC_2022.pdf") #Comment for SIP
  pdf(file=plotname, height = 6.5, width = 6.5, paper = "special") #Comment for SIP
  
}

library(pROC)
obsnoice = array(NA)

for (i in 1:length(date_num)) {
  if (is.na(date_num[i])) {
    obsnoice[i] = TRUE
  }
  else {
    obsnoice[i] = FALSE
  }
  
}
TPR=array(NA)
FPR=array(NA)
tTP=array(NA)
tTN=array(NA)
tFP=array(NA)
tFN=array(NA)
cutoff = array(NA)
for (i in 0:100) {
  cutoff[i+1]=0.01*i
  beta_curr = array(NA)
  for (r in 1:length(pr_pr_beta_cpt))
  {
    if(pr_pr_beta_cpt[r] < cutoff[i+1])
    {
      beta_curr[r]=FALSE;
    }
    else
    {
      beta_curr[r]=TRUE;
    }
  }
  TP = 0
  FP = 0
  TN = 0
  FN = 0
  
  # Determine whether each prediction is TP, FP, TN, or FN
  for (q in 1:length(pr_pr_beta_cpt)){
    if (obsnoice[q] && beta_curr[q]){
      TP = 1+TP
    }
    
    if (obsnoice[q] && !beta_curr[q]){
      FN = 1+FN
      
    }
    if (!obsnoice[q]&& !beta_curr[q]){
      TN = 1+TN
      
    }
    if (!obsnoice[q] && beta_curr[q]){
      FP = 1+FP
      
    }
  }
  tTP[i+1] = TP
  tTN[i+1] = TN
  tFP[i+1] = FP
  tFN[i+1] = FN
  TPR[i+1] = TP / (TP + FN)
  FPR[i+1] = FP / (FP + TN)
  
  
}

df = data.frame(cutoff = cutoff)
df$TPR = TPR
df$FPR = FPR
df$tTP = tTP
df$tTN = tTN
df$tFP = tFP
df$tFN = tFN
library(pracma)
s = (trapz(FPR,TPR))
plot(df$FPR,df$TPR,type='o',xlim=c(0,1),ylim=c(0,1),main="ROC Curve", xlab="False Positive Rate", ylab="True Positive Rate",
     col="lightgreen",pch = 16,lwd=3)
lines(c(0,1),c(0,1),lty=3, lwd=3,col="blue")
legend("bottomright",legend=c(paste("Beta Model (AUC: ",-1*round(s,2),")",sep=""),"Random"),
       col=c("lightgreen","Blue"), lty=c(1,3), lwd = 3,cex=0.8)

if (exportplots) {
  dev.off()
}




###########################################################
###########################################################
## Below: two sections of unused code -- keep in case needed
###########################################################
###########################################################


## Original Method from Previous Paper - Didn't lead to a significant reduction in variables ##
#beta.step	<-stepGAIC(beta.gam,direction=c("both"),type="vcov")		## Automated forward-backward step
# 
# s = summary(beta.step)
# listofcols=array(NA)
# for (i in c(2:(length(s[,4])-1))) {
#   if (s[i,4]<0.01) {
#     print(row.names(s)[i])
#     listofcols = append(listofcols,row.names(s)[i])
#   }
# }

 # data.sub = cbind(teleall[,listofcols[2:length(listofcols)]])

###########################################################
###########################################################
# data.sub.two = tele[temp_cols.two]
# data.sub.exp = tele[temp_cols.exp]

# ndb.two 	= as.data.frame(data.sub.two)
# ndb.exp		= as.data.frame(data.sub.exp)

# colnames(ndb.two)<-names(data.sub.two)
# colnames(ndb.exp)<-names(data.sub.exp)

# mod.beta.two = betareg(avg10day.max~.,data=ndb.two)
# mod.beta.exp = betareg(avg10day.max~.,data=ndb.exp)
# step(gamlss(avg10day.max~.,data=ndb.exp))

# summary(mod.beta.two); summary(mod.beta.exp)

# End of Selections

# ndb=as.data.frame(data.sub)
# colnames(ndb)<-names(data.sub)

# mod.beta.max=betareg(avg10day.max~.,data=ndb)
# summary(mod.beta.max)