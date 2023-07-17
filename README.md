# The Apostle Islands Ice Cover Model

This repository contains the code used for the development of the Apostle Islands Ice Cover Model, which serves as a companion to the research paper currently under review in Geophysical Research Letters (GRL). It provides the necessary code and data to reproduce the findings and results presented in the paper.

The Apostle Islands Ice Cover Model is designed to forecast ice cover in the Apostle Islands region of the Great Lakes. It incorporates various teleconnections and local data to predict ice cover. The code in this repository represents the implementation of the model, along with the necessary data processing and analysis steps.

## Current Status

As of the current version, the code in this repository is fully functional and capable of predicting ice cover in the Apostle Islands region. However, please take note of the following:

1. Usage and Argument Handling: It is important to provide the appropriate arguments and use the code as intended to ensure accurate results. The code does not currently include almost any error handling for invalid inputs. We recommend reading the paper to understand the correct usage.

2. Code Comments and Documentation: There are inline comments and basic documentation, but there may be areas that require further clarification. We are  working on improving the comments and documentation to enhance code readability!

3. Testing and Validation: The code has undergone testing by us. However, additional testing and validation by external users is not yet done.

Please feel free to reach out if you have any questions, encounter any issues

## Getting Started
To get started with the Apostle Islands Ice Cover Model, please follow the steps below:

### Installation

1. [Clone the Repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository): Begin by cloning this repository to your local machine. You can do this by clicking on the green "Code" button in the repo and following the steps there. If you have ssh, it'll look like this:
    git clone git@github.com:manishrv123/Apostle_Islands_Ice_Cover_Model_Development.git
2. Open the Project in RStudio: Once the repository is cloned, navigate to the project directory and open the ".RProj" file using RStudio. Ensure that you have R version 4.2.2 (roughly, it's not an exact science hah) installed on your system.
3. Package Installation: The necessary packages and dependencies will be managed using the 'renv' package. Upon opening the project in RStudio, 'renv' will automatically detect the project environment and install the required packages. If prompted, confirm the installation of missing packages.
4. If you encounter any issues during the installation process, please reach out to manishrv@umich.edu

### Usage

The model was run with RStudio on Windows 11 (Verified with the most updated versions of R, RStudio, and Windows on 7/11/2023). There are two ways to run this project.

Preferred Method: Run the Model with Precompiled Ice Cover Data

1. Open the project in RStudio by clicking on the .Rproj file.
2. Source the Code/ModelDriver.R file. This script will execute all the necessary scripts to run the model using the precompiled ice cover data.

Alternative Method: Recreate the Project from Scratch

1. Open the project in RStudio by clicking on the .Rproj file.
2. ****Note: This step may take a long time to complete.**** Source the Code/IceCoverDataDriver.R file. This script collects the ice cover data specifically for the Apostle Islands.
3. Source the Code/ModelDriver.R file. This will execute all the scripts required to run the model.


Please note that the preferred method is recommended as it saves time by utilizing the precompiled data. However, if you prefer to recreate the project from scratch or need to update the ice cover data, you can follow the alternative method.

### Repo Organization

The repository is organized into the following sections:

#### Code
The code folder consists of two main parts:

1. IceCoverDataDriver: This script downloads Great Lakes ice cover data and subsets it specifically for the Apostle Islands.
2. ModelDriver: This script runs the actual ice cover model. It includes the "CodeSegment" folder, which contains the different components of the model, and the "PlotCode" folder, which contains individual R scripts for generating specific plots.
#### Data
The data folder contains all the input data required for the model. You only need to have the main spreadsheets in this folder. The subdirectory "IceCoverData" is used for preprocessing the dailyIceCover.csv file. For more detailed information on the data sources, please refer to the paper or the README file provided in the folder.

#### Plots
The plots section is where the output plots generated by the model are saved. Please note that there are already example plots available in this folder to provide an idea of the expected output. These plots will be overwritten when you run the code.

Please explore the respective folders to access the necessary code, data, and output plots of the model:

## Contributing

The code is originally sourced from the 2015 original project: Ji, X., Gronewold, A. D., Daher, H., & Rood, R. B. (2019). Modeling seasonal onset of coastal ice. Climatic Change, 154 (1), 125–141. doi: 10.1007/s10584-019455-02400-1

Updates to the code base come from this paper's authors.

## Contact

If you have any questions or feedback, please feel free to contact the corresponding author: drewgron@umich.edu. In case of GitHub-specific issues, contact manishrv@umich.edu
