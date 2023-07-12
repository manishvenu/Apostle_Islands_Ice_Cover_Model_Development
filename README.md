# The Apostle Islands Ice Cover Model

This repo is a compilation of code used for the Apostle Islands Ice Cover Model and is the code companion for a paper currently under review in the Geophysical Research Letters Publication.


## Current Status

- There are NO protections against bad arguments! If not used in the intended manner, the code will break!
- Docs and code are not well commented yet. 

## Getting Started

### Installation

Clone the repo. 

### Usage

This project was run with RStudio on Windows 11. Because reading and downloading ice cover data takes a long time, there is a two ways to run this project.

Run only the main code with the already compiled ice cover data:
1. Open the project in RStudio with the .Rproj file
2. Run the Code/ModelDriver.R File. This runs all other scripts.


To recreate the project from scratch:
1. Open the project in RStudio with the .Rproj file
2. ****THIS TAKES A LONG TIME**** Run the Code/IceCoverDataDriver.R File. This collects the ice cover data for the Apostle Islands
3. Run the Code/ModelDriver.R File. This runs all other scripts.

### Contributing

The code is largely sourced from the 2015 original project: Ji, X., Gronewold, A. D., Daher, H., & Rood, R. B. (2019). Modeling seasonal onset of coastal ice. Climatic Change, 154 (1), 125–141. doi: 10.1007/s10584-019455-02400-1

## Contact

If you have any questions or feedback, please feel free to contact the corresponding author: drewgron@umich.edu. In case of github-specific issues, contact manishrv@umich.edu