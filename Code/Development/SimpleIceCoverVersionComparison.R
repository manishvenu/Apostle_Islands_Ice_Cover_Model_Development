## Ice Cover Comparison Analysis ##

# Libraries

library(lubridate)

# Set-Up Vars

data_dir= file.path("Data")

# Read in New Ice Cover Data

daily.ice.new = read.csv(file.path(data_dir,"dailyIceCover.csv"), header = FALSE, sep = ",")
daily.ice.new = na.omit(daily.ice.new)
# Read in Old Ice Cover Data
daily.ice.old = read.csv(file.path(data_dir,"Development","dailyIceTimeSeries_1973_2022.csv"), header = FALSE, sep = ",")


for (i in seq_along(daily.ice.old$V3)) {
  if (as.numeric(daily.ice.old$V3[i])<10) {
    daily.ice.old$V3[i] = paste0("0",daily.ice.old$V3[i])
  }
  if (as.numeric(daily.ice.old$V2[i])<10) {
    daily.ice.old$V2[i] = paste0("0",daily.ice.old$V2[i])
  }
}
for (i in seq_along(daily.ice.new$V3)) {
  if (as.numeric(daily.ice.new$V3[i])<10) {
    daily.ice.new$V3[i] = paste0("0",daily.ice.new$V3[i])
  }
  if (as.numeric(daily.ice.new$V2[i])<10) {
    daily.ice.new$V2[i] = paste0("0",daily.ice.new$V2[i])
  }
}
# Recognize Dates
daily.ice.old$date = ymd(paste0(daily.ice.old$V4,daily.ice.old$V2,daily.ice.old$V3))
daily.ice.new$date = ymd(paste0(daily.ice.new$V4,daily.ice.new$V2,daily.ice.new$V3))


merged_ice_cover= merge(x= na.omit(daily.ice.old), y= na.omit(daily.ice.new), by= 'date', all.x= F)
length=50
plot(merged_ice_cover$date[0:length],merged_ice_cover$V5.x[0:length])
points(merged_ice_cover$date[0:length],merged_ice_cover$V5.y[0:length])
plot(merged_ice_cover$V5.x,merged_ice_cover$V5.y)
write.table(merged_ice_cover, file = "Data/Development/IceCoverComparisonMerged.csv",sep=",", row.names = FALSE)
