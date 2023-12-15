#----------------------------------------------------------------------------------------------
# LOAD LIBRARIES
#----------------------------------------------------------------------------------------------

library(tidyverse)
library(lubridate)
source("Code/CodeHelpers/GeneralHelpers.R")
source("Code/CodeHelpers/IceCoverDataHelpers.R")



#----------------------------------------------------------------------------------------------
# INTRODUCTION
#----------------------------------------------------------------------------------------------

# The Great Lakes Ice Cover Data needs to be processed into just Apostle Islands Ice Cover Data
# It is the biggest time suck in the entire project. BUT, it only needs to be done one time per area (The Apostle Islands).
# This is the code that does it. 

#----------------------------------------------------------------------------------------------
# DOWNLOAD ICE COVER DATA
#----------------------------------------------------------------------------------------------
# These functions download the yearly zip archives of ice cover data and unzips the data. 
# The unzip function is the main slow part, and it does run into errors, so may have to run this multiple times.
# It is fairly slow, if you would like to do it manually, follow the below steps:
# 1. Head to https://www.glerl.noaa.gov/data/ice/#historical  and download the data by year ASCII files (comes as .zip)
# 2. Extract the zip files into a specific directory (That directory should have the extracted folder called grid[YEAR]), and set that directory to the variable "data_dir".
# 3. Add the specific years you extracted to the "ice_years_of_interest" variable
#That's all the following code does

set_working_directory_to_project_file() # This function doesn't do anything, it's just a reminder for you to do that.
check_for_and_create_data_folder()
data_dir = create_ice_cover_data_folder()
ice_years_of_interest = c(1973:2022)
download_ice_cover_data_by_year(ice_years_of_interest,data_dir)


#----------------------------------------------------------------------------------------------
# PROCESS ICE COVER DATA
#----------------------------------------------------------------------------------------------


## Set up arrays of data ##
dates=array(NA)
daily_avg_adj= array(NA)
counter=0


## Check if the Output Ice Cover Data file exists and how much data is already in it## 

if (file.exists("Data/dailyIceCoverRedo.csv")) {
  daily.ice = read.csv('Data/dailyIceCover.csv', header = FALSE, sep = ",") 
  dates = sprintf("%04d%02d%02d", daily.ice$V4,daily.ice$V2,daily.ice$V3)
  daily_avg_adj = daily.ice$V5
  start_year = year(ymd(dates[1]))
  end_year =  year(ymd(dates[length(dates)]))
  
  ## Remove years of interest that are already in output spreadsheet ##
  ice_years_removal_iterator = ice_years_of_interest
  removal_years = c()
  for (year_index in seq_along(ice_years_removal_iterator)){
    if (!(ice_years_removal_iterator[year_index]<start_year) | !(ice_years_removal_iterator[year_index]>end_year) ) {
      removal_years = c(removal_years,year_index)
      print(paste("Removed:",ice_years_removal_iterator[year_index]))
    }
  }
  ice_years_of_interest = ice_years_removal_iterator[-removal_years]
  
}

counter=length(dates)+1
## Read in Coordinates file for ice cover data ##
latitude = as.numeric(scan("Data/IceCoverData/1024_latgrid.txt", what = "double()"))
longitude = as.numeric(scan("Data/IceCoverData/1024_longrid.txt", what = "double()"))


## Index to Apostle Islands Area ##
index_array = which(latitude >=46.8485 & latitude<=46.9704 & 
                      longitude>=-91.1363 & longitude <=-90.9392) 



for (cur_ice_year in ice_years_of_interest) {
  folder_path =file.path(data_dir,paste0("grid",cur_ice_year))
  files <- list.files(path=folder_path, pattern="*.ct", full.names=TRUE, recursive=FALSE)
  for (file in files) {

    ## Get Date ##
    filename = str_split(file,"/")[[1]][4]
    file_date= as.numeric(format(as.Date(filename,"g%Y%m%d.ct"),'%Y%m%d'))
    file_date = ymd(file_date)
    year(file_date) = cur_ice_year
    dates[counter] = as.numeric(format(as.Date(file_date,"%Y-%m-%d"),'%Y%m%d'))
    ## Read Data ##
    ice_data_raw <- scan(file, what = "double()", skip = 7)
    
    ## Subset to area of interest ## 
    region_ice_cover = as.numeric(ice_data_raw[index_array])
    

    ## Remove Values with no data ##
    No_Data = -99 
    land_value = -1
    indexes_to_remove = which(region_ice_cover == land_value | region_ice_cover == No_Data | is.na(region_ice_cover) ==TRUE)
    region_ice_cover = region_ice_cover[-indexes_to_remove]
    
    ## Take Mean Value ##
    daily_avg_adj[counter] = mean(region_ice_cover)
    print(dates[counter])
    print(daily_avg_adj[counter])
    counter=counter+1
  }
}


dates = ymd(dates)
days_from_december_first = array(NA)
for (i in unique(year(dates))) {
  if (!is.na(i)) {
    for (d in seq_along(dates)) {
      if (!is.na(dates[d]) & year(dates[d])==i) {
        if (month(dates[d])>9) {
          dec1 = ymd(paste0(i,"12","01"))
        } else {
          dec1 = ymd(paste0(i-1,"12","01"))
        }
        interv= 100 + interval(dec1,dates[d])/days(1)
        days_from_december_first[d] = interv
      }else if (!is.na(dates[d]) & year(dates[d])>i) {
        print("Moving on to new year")
        break
      }
      
    }     
  }
}
final = data.frame(DaysfromDecemberFirst = days_from_december_first,month = month(dates),day = day(dates),year = year(dates),IceCover = daily_avg_adj)
write.table(final, file = "Data/dailyIceCoverRedo.csv",sep=",",col.names=FALSE, row.names = FALSE)
