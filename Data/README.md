# Spreadsheet Data Info & Sources:

## dailyIceTimeSeries - 
	a) Holds ice cover data around the Apostle Islands from 1972-2022, Dec-May
	b) From GLERL, "https://www.glerl.noaa.gov/data/ice/#historical under 'Data files by Year'", see the code for how it was processed.
## DuluthAirTemp1972_2022
	a) Air Temp in Fahrenheit 1972-2022, Aug-Dec: https://www.ncdc.noaa.gov/cdo-web/datasets/GHCND/stations/GHCND:USW00014913/detail
	b) Station #USW00014913 was stitched from max & min temperatures
## ModeledWaterTemperatureStitch
	a) Water Temp same style as Air Temp
	b) Modeled temperature until 1995 (https://www.glerl.noaa.gov/data/dashboard/data/hydroIO/temps/superiorWaterTempModMo.csv) stitched with observed (https://coastwatch.glerl.noaa.gov/statistic/csv/all_year_glsea_avg_s_C.csv, was averaged monthly)

## OLR
	a) From: https://www.cpc.ncep.noaa.gov/data/indices/olr
Public Site: https://www.ncei.noaa.gov/access/monitoring/enso/olr
	b) 1972,1973,1978 ->Filled based on nearby year, 2009 - First 4 Months. 
	c) Name: "OUTGOING LONG WAVE RADIATION EQUATOR/160E-160W                                  
                    STANDARDIZED    DATA "
## AMO
	a) Raw Data: https://psl.noaa.gov/data/correlation/amon.us.long.data, https://psl.noaa.gov/data/timeseries/AMO/
	b) Notes: AMO is unsmoothed data
	c) Location: /SpreadsheetData
## TNH
	a) Raw Data: https://www.cpc.ncep.noaa.gov/data/teledoc/tnh.shtml -> Access the ftp: ftp://ftp.cpc.ncep.noaa.gov/wd52dg/data/indices/tnh_index.tim
	b) Adjusments: None
	c) Location: /SpreadsheetData
	