###############################################################
###############################################################
#### R code for APIS manuscript -- 2022 Update 
###############################################################
###############################################################
############### INTRODUCTION ##################################
# This is the main driver file. You need a few spreadsheets (should be in "Data" Folder) to make this code run: 
# The Ice Data, TNH data, AMO data, OLR data, WaterTemp Data
# Plotter Scripts are sourced seperately and only work in conjuction with this code.


##################### Libraries ########################
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
library(here)

##################### File Paths ##################################################################

data_dir = "Data/"
plot_dir = "Plots/"
code_dir = "Code/"
plot_code_dir = "Code/PlotCode/"
export_plots_to_plots_folder=FALSE

################## Set Correct Working Directory ################################################


print(here()) # Set Working Directory to Project File 
source(file.path(code_dir,"GeneralHelpers.R")) # Holds useful helper functions

################## Check for file dependencies ###################################################

if (!file.exists(file.path(data_dir,"dailyIceCover.csv")) | 
    !file.exists(file.path(data_dir,"TNH.csv")) |
    !file.exists(file.path(data_dir,"OLR.csv")) |
    !file.exists(file.path(data_dir,"ModeledWaterTemperatureStitch.csv")) |
    !file.exists(file.path(data_dir,"DuluthAirTemp1972_2021.csv")) |
    !file.exists(file.path(data_dir,"AMO.csv"))) {
  stop("File Dependency Missing, did you properly clone the repository? Or is the working directory not set correctly?")
}
  
################# Set Globals ####################################################################

print("Set Globals")
last_year = 2022
first_year = 1973
number_of_years = last_year - first_year+1

################## Process Apostle Islands Ice Cover Data ########################################
# This script reads in the processed ice cover data from the IceCoverData scripts and returns a few things.
# 1. A rolling 10-day average of ice cover
# 2. date_num: an array of the first day during the year ice cover rolling average crosses 90%
# 3. avg10day.max: an array of the maximum ice vover rolling average percentage that year (0-100)

print("Processing Apostle Islands Ice Cover Data")
source(file.path(code_dir,"ProcessApostleIslandsIceCoverData.R"))

############################# Plots! ###############################
# These scripts are a couple different visualizations of the data:
# 1. The first file is graph of ice cover percentage through the year. Since there are 50 years, there are 50 panels
# 2. The second file just plots the date_num array. That's the date every year that ice cover exceeds 90% 10-day rolling average.

print("Plotting Ice Cover Data")
source(file.path(plot_code_dir,"DailyIceCoverSplitByYearPlotCode.R"))
source(file.path(plot_code_dir,"DateofSeasonalIceOnsetPlotCode.R"))

############################# Fix avg10day ice 0 and 1 problem so that can be used in gamlss model by formula (y*(n-1)+0.5) ####

avg10day.max=avg10day.max*0.01

############################# Gather teleconnection and local data #################################
# Collect all of the teleconnection and local data
# The only thing you should use further on from this code is the tele* dataframes.
print("Gathering Teleconnections and Local Data")
source(file.path(code_dir,"GatherTeleconnectionsAndLocalData.R"))

############################# Plots! #################################################################
# Plots:
# 1. This plots the Teleconnections and Local Data through the years
print("Plotting Teleconnection Data")
source(file.path(plot_code_dir,"TeleconnectionPlotCode.R"))

###############Assess correlation of teleconnection indices:#####################################################
# Pretty much it. Find the correlations and remove all the data that's correlated. We keep the earlier series in the dataset.
# Should only need to use the tele and teleall dataframes from this code. It holds all the input data.
print("Finding Correlations in Data")
source(file.path(code_dir,"FindCorrelationsInData.R"))


########################## Cox Model ####################
# This is every step we took with the cox model. you'll notice that there are several different ways we decided on variables
print("Running Cox Model Steps")
source(file.path(code_dir,"CoxModel.R"))

######################### Beta Model ####################
# The Beta Model, you'll notice there are several steps we tried to find relevant variables.

print("Running Beta Model Steps")
source(file.path(code_dir,"BetaModel.R"))
source(file.path(plot_code_dir,"BetaModelMaximumPlotCode.R"))

######################## Final Plots! #######################
# Plots!
# 1. Histograms: A way of validating the models, deprecated!
# 2. ParameterSummary: This is in the manuscript, it's a way of seeing how relevant each variable was, comparing the full-period with both split periods
# 3. YearlyCoxBeta: It's a yearly look at model results (Why there is 50 panels). The Cox model has a daily value while the Beta model is one annual value.
# 4. ModelValidation: Using a leave-one-out validation, we can compare both splotmode and full model results against actual model results
# 5. SummaryCoXBeta: The original paper used this visual as aconclusion
# 6. FullModelIceOnsetSummary: Showing the data of ice onset against what both models said would happen. This is in the paper
# 7. ROCCurve: If interested, you can do ROC curves with the Beta Model

print("Final Plots")
#source(file.path(plot_code_dir,"HistogramsCoxBetaPlotCode.R"))
source(file.path(plot_code_dir,"ParameterSummaryPlotCode.R"))
source(file.path(plot_code_dir,"YearlyCoxBetaPlotCode.R"))
source(file.path(plot_code_dir,"ModelValidationPlotCode.R"))
source(file.path(plot_code_dir,"SummaryCoxBetaOld.R"))
source(file.path(plot_code_dir,"FullModelIceOnsetSummaryPlotCode.R"))
#source(file.path(plot_code_dir,"ROCCurvePlotCode.R")) 

