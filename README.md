# The Apostle Islands Ice Cover Model

This repo is a compilation of code used for the Apostle Islands Ice Cover Model and is the companion (code & data) for a paper currently under review in the Geophysical Research Letters Publication.


## Current Status

- There are NO protections against bad arguments! If not used in the intended manner, the code will break!
- Docs and code are not well commented yet. Testing of initial repo by unrrelated user is yet to be completed.

## Getting Started

### Installation

[Clone the repo](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) 

### File Descriptions

#### Code
There are two parts to this project. 
1. The first (IceCoverDataDriver) downloads Great Lakes ice cover data and subsets it to the Apostle Islands. 
2. The second (ModelDriver) runs the actual ice cover model. It runs the "CodeSegement" folder, which is a logical break down of all the different parts of the model, and the "PlotCode" folder, which is an R Script for each plot.

#### Data
This is where all the input data is stored. You need the main spreadsheets in the folder, but the subdirectory, "IceCoverData" is only for preprocessing the dailyIceCover.csv. See the paper for detailed description of where data is from and/or the DataREADME file in the folder.

#### Plots
This is where output plots are written to. There are already plots here to show you what theoutput is supposed to look like (will be overwritten when you run the code)

### Usage

This project was run with RStudio on Windows 11 (Verified with most updated versions of RStudio and Windows on 7/11/2023). Because reading and downloading ice cover data takes a long time, there are two ways to run this project.

PREFERRED: Run only the main code with the already compiled ice cover data:
1. Open the project in RStudio with the .Rproj file
2. Run the Code/ModelDriver.R File. This runs all other scripts.


POSSIBLE: To recreate the project from scratch:
1. Open the project in RStudio with the .Rproj file
2. ****THIS TAKES A LONG TIME**** Run the Code/IceCoverDataDriver.R File. This collects the ice cover data for the Apostle Islands
3. Run the Code/ModelDriver.R File. This runs all other scripts.

### Contributing

The code is originally sourced from the 2015 original project: Ji, X., Gronewold, A. D., Daher, H., & Rood, R. B. (2019). Modeling seasonal onset of coastal ice. Climatic Change, 154 (1), 125–141. doi: 10.1007/s10584-019455-02400-1

Updates to the code base come from this paper's authors.

## Contact

If you have any questions or feedback, please feel free to contact the corresponding author: drewgron@umich.edu. In case of github-specific issues, contact manishrv@umich.edu