# Spreadsheet Data Info & Sources:

## dailyIceTimeSeries - 
1. Holds ice cover data around the Apostle Islands from 1972-2022, Dec-May
2. From GLERL, "https://www.glerl.noaa.gov/data/ice/#historical under 'Data files by Year'", see the code for how it was processed.
## DuluthAirTemp1972_2022
1. Air Temp in Fahrenheit 1972-2022, Aug-Dec: https://www.ncdc.noaa.gov/cdo-web/datasets/GHCND/stations/GHCND:USW00014913/detail
2. Station #USW00014913 was stitched from max & min temperatures
## ModeledWaterTemperatureStitch
1. Water Temp same style as Air Temp
2. Modeled temperature until 1995 (https://www.glerl.noaa.gov/data/dashboard/data/hydroIO/temps/superiorWaterTempModMo.csv) stitched with observed (https://coastwatch.glerl.noaa.gov/statistic/csv/all_year_glsea_avg_s_C.csv, was averaged monthly)

## OLR
1. From: https://www.cpc.ncep.noaa.gov/data/indices/olr
Public Site: https://www.ncei.noaa.gov/access/monitoring/enso/olr
2. 1972,1973,1978 ->Filled based on nearby year, 2009 - First 4 Months. 
3. Name: "OUTGOING LONG WAVE RADIATION EQUATOR/160E-160W                                  
                    STANDARDIZED    DATA "
## AMO
1. Raw Data: https://psl.noaa.gov/data/correlation/amon.us.long.data, https://psl.noaa.gov/data/timeseries/AMO/
2. Notes: AMO is unsmoothed data
## TNH
1. Raw Data: https://www.cpc.ncep.noaa.gov/data/teledoc/tnh.shtml -> Access the ftp: ftp://ftp.cpc.ncep.noaa.gov/wd52dg/data/indices/tnh_index.tim
2. Adjusments: None

# IceCoverData Folder
1. Projected size of all ice cover data is slightly less than 30 GB. Running the ice cover driver will download that much. Doing a smaller run of a coupe years of ice_years_of_interest could be much more manageable and confirm reproducibility.
	