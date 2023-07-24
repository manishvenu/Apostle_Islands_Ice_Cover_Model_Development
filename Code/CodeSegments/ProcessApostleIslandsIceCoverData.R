
## Read in ice cover data
daily.ice = read.csv(file.path(data_dir,"dailyIceCover.csv"), header = FALSE, sep = ",")

# Erase any NA rows, should only be the first row.
daily.ice = na.omit(daily.ice)


## Remove months after May and before November
del.index=array(NA)
ind.ct=1
daily.ice$V1=daily.ice$V1-100
for (i in 1:length(daily.ice$V1)){
  if (daily.ice$V2[i] >= 6 & daily.ice$V2[i] <= 11){
    del.index[ind.ct]=i
    ind.ct=ind.ct+1
  }
}
daily.ice=daily.ice[-del.index,]

## Create the 10-day rolling average and find the day (after December 1st) when ice cover goes over 90% every year ## 
rownames(daily.ice)<-seq(1,length(daily.ice$V1),1)
daily.ice<-daily.ice[,c(-2,-3)]
daily.ice$V6=array(NA)						                       						# create a new column to make the 10day average
colnames(daily.ice)<-c("day_number","year","ice","avg10day_ice")
date_num=array(NA)                                                  # Where we store the first day of "solid" ice, or 90% ice cover.
avg10day.max=array(NA)							                      					# max of rolling average in each year
month1 <- c(12,1,2,3,4,5)

for (i in first_year:last_year){ 
  yr.index=array(NA)
  count=1
  for (j in 1:length(daily.ice$day_number)){
    if(daily.ice$year[j]==i){
      yr.index[count]=j
      count=count+1
    }
  }
  for (k in 1:(length(yr.index)-9)){ # This is the rolling average loop
    daily.ice$avg10day_ice[yr.index[1]+k+8]=(sum((daily.ice$ice)[(yr.index[1]-1+k):(yr.index[1]+8+k)]))/10 #Calculation of Average
  }
  for (l in 10:length(yr.index)){    # This is the over 90% ice cover loop
    if(daily.ice$avg10day_ice[yr.index[l]]>=90){
      date_num[i-first_year+1]=daily.ice$day_number[yr.index[l]]
      break
    }
  }
  avg10day.max[i-first_year+1]=max(na.omit(daily.ice$avg10day_ice[yr.index[1]:yr.index[k+9]])) # This is the day of maximum ice cover
  x=i
  
}
if (avg10day.max[length(avg10day.max)]<90){
  date_num[length(avg10day.max)] = NA
} 