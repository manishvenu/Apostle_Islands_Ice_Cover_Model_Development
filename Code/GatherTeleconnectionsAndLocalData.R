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

airTmp_raw = read.csv(file.path(data_dir,"DuluthAirTemp1972_2021.csv"))
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

water_temp_raw = read.csv(file.path(data_dir,"ModeledWaterTemperatureStitch.csv"))
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
tnh_raw = read.csv(file.path(data_dir,"TNH.csv"))
tnh_raw = tnh_raw[,-1]
tnh = array(NA)
counter = 1
for (i in 1:length(tnh_raw[,1])) {
  for (j in 1:length(tnh_raw[1,])) {
    tnh[counter] = tnh_raw[i,j]
    counter = counter + 1
  }
}
#######. OLR ########
OLR_raw = read.csv(file.path(data_dir,"OLR.csv"))
OLR_raw = OLR_raw[,-1]
OLR = array(NA)
counter = 1
for (i in 1:length(OLR_raw[,1])) {
  for (j in 1:length(OLR_raw[1,])) {
    OLR[counter] = OLR_raw[i,j]
    counter = counter + 1
  }
}
#######. AMO ########
AMO_raw = read.csv(file.path(data_dir,"AMO.csv"))
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
year_column = rep(x = c((first_year-1):last_year), times = 1, each = 5)
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
  while (length(tele_data2[[i]]) > number_of_years*5) { #250 years in applicable model
    tele_data2[[i]] = tele_data2[[i]][-length(tele_data2[[i]])]
  }
}
tele_data = data.frame(tele_data2,
                       stringsAsFactors = F)

latest_year = tele_data[[1]][length(tele_data[[1]])]
avg10day.max = avg10day.max[1:((latest_year - first_year+1)+1)] #just cutting to match data timeframes
index<-which(tele_data[,2] == 12)
index.mon=c("aug","sep","oct","nov","dec")
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