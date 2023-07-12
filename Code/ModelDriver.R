#----------------------------------------------------------------------------------------------
# R Code for APIS 2022 Update
#----------------------------------------------------------------------------------------------
# This is the main driver file. 
# Plotter and Code Segment Scripts are sourced seperately and only work in conjuction with this code.


#----------------------------------------------------------------------------------------------
# IMPORT LIBRARIES
#----------------------------------------------------------------------------------------------
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

#----------------------------------------------------------------------------------------------
# CREATE FILE PATHS
#----------------------------------------------------------------------------------------------

data_dir = "Data/"
plot_dir = "Plots/"
code_dir = "Code/"
code_segment_dir = "Code/CodeSegments/"
plot_code_dir = "Code/PlotCode/"
code_helpers_dir = "Code/CodeHelpers/"

#----------------------------------------------------------------------------------------------
# SET CORRECT WORKING DIRECTORIES
#----------------------------------------------------------------------------------------------


print(here()) # Set Working Directory to Project File -> Make sure the output here is set to the same directory level as the project folder
source(file.path(code_helpers_dir,"GeneralHelpers.R")) # Holds useful helper functions

#----------------------------------------------------------------------------------------------
# CHECK FOR DATA FILE DEPENDENCIES
#----------------------------------------------------------------------------------------------

if (!file.exists(file.path(data_dir,"dailyIceCover.csv")) | 
    !file.exists(file.path(data_dir,"TNH.csv")) |
    !file.exists(file.path(data_dir,"OLR.csv")) |
    !file.exists(file.path(data_dir,"ModeledWaterTemperatureStitch.csv")) |
    !file.exists(file.path(data_dir,"DuluthAirTemp1972_2021.csv")) |
    !file.exists(file.path(data_dir,"AMO.csv"))) {
  stop("File Dependency Missing, did you properly clone the repository? Or is the working directory not set correctly?")
}
  
#----------------------------------------------------------------------------------------------
# SET GLOBALS
#----------------------------------------------------------------------------------------------

print("Set Globals")
last_year = 2022
first_year = 1973
number_of_years = last_year - first_year+1
export_plots_to_plots_folder=FALSE

#----------------------------------------------------------------------------------------------
# PROCESS APOSTLE ISLANDS ICE COVER DATA
#----------------------------------------------------------------------------------------------
# This script reads in the processed ice cover data from the IceCoverData scripts and returns a few things.
# 1. A rolling 10-day average of ice cover
# 2. date_num: an array of the first day during the year ice cover rolling average crosses 90%
# 3. avg10day.max: an array of the maximum ice vover rolling average percentage that year (0-100)

print("Processing Apostle Islands Ice Cover Data")
source(file.path(code_segment_dir,"ProcessApostleIslandsIceCoverData.R"))

#----------------------------------------------------------------------------------------------
# PLOT ICE COVER DATA
#----------------------------------------------------------------------------------------------
# These scripts are a couple different visualizations of the data:
# 1. The first file is graph of ice cover percentage through the year. Since there are 50 years, there are 50 panels
# 2. The second file just plots the date_num array. That's the date every year that ice cover exceeds 90% 10-day rolling average.

print("Plotting Ice Cover Data")
source(file.path(plot_code_dir,"DailyIceCoverSplitByYearPlotCode.R"))
source(file.path(plot_code_dir,"DateofSeasonalIceOnsetPlotCode.R"))

#----------------------------------------------------------------------------------------------
# FIX OUTPUT DATASET FOR USE LATER ON
#----------------------------------------------------------------------------------------------
# Fix avg10day ice 0 and 1 problem so that can be used in gamlss model by formula (y*(n-1)+0.5) 

avg10day.max=avg10day.max*0.01

#----------------------------------------------------------------------------------------------
# GATHER TELECONNECTION AND LOCAL DATA
#----------------------------------------------------------------------------------------------
# Collect all of the teleconnection and local data
# The only thing you should use further on from this code is the tele* dataframes.
print("Gathering Teleconnections and Local Data")
source(file.path(code_segment_dir,"GatherTeleconnectionsAndLocalData.R"))

#----------------------------------------------------------------------------------------------
# PLOT TELECONNECTION AND LOCAL DATA
#----------------------------------------------------------------------------------------------
# Plots:
# 1. This plots the Teleconnections and Local Data through the years
print("Plotting Teleconnection Data")
source(file.path(plot_code_dir,"TeleconnectionPlotCode.R"))

#----------------------------------------------------------------------------------------------
# ASSESS CORRELATION OF INPUT DATA
#----------------------------------------------------------------------------------------------
# Pretty much it. Find the correlations and remove all the data that's correlated. We keep the earlier series in the dataset.
# Should only need to use the tele and teleall dataframes from this code. It holds all the input data.
print("Finding Correlations in Data")
source(file.path(code_segment_dir,"FindCorrelationsInData.R"))


#----------------------------------------------------------------------------------------------
# RUN COX MODEL 
#----------------------------------------------------------------------------------------------
# This is every step we took with the cox model. you'll notice that there are several different ways we decided on variables
print("Running Cox Model Steps")
source(file.path(code_segment_dir,"CoxModel.R"))

#----------------------------------------------------------------------------------------------
# RUN BETA MODEL
#----------------------------------------------------------------------------------------------
# The Beta Model, you'll notice there are several steps we tried to find relevant variables.

print("Running Beta Model Steps")
source(file.path(code_segment_dir,"BetaModel.R"))
source(file.path(plot_code_dir,"BetaModelMaximumPlotCode.R"))

#----------------------------------------------------------------------------------------------
# RUN CONCLUDING PLOTS
#----------------------------------------------------------------------------------------------
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

