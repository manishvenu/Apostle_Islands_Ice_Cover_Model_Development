library(utils)
library(here)


# This function creates a folder named "Data" in the directory if it doesn't exist
check_for_and_create_data_folder <- function() {
  print("Creating Data Directory")
  
  if (!dir.exists("Data")) {
    dir.create("Data")
  }
  
}

# This function sets the directory to one level up IF the currenty directory name is Code, R, or Scripts. It is not really used.
set_working_directory_to_project_file <- function() {
  print("Setting Working Directory to project file")
  
  vector_of_folders = strsplit(here(),"/")[[1]]
  proj_directory = vector_of_folders[length(vector_of_folders)]
  if (proj_directory == "R" | proj_directory == "Code" |proj_directory == "Scripts" ) {
    setwd(dirname(here()))
    print("One Directory Up")
    
  } else {
    proj_directory = vector_of_folders[length(vector_of_folders)-1]
    if (proj_directory == "R" | proj_directory == "Code" |proj_directory == "Scripts" ) { # Go One more Directory deep
      setwd(dirname(dirname(here())))
      print("Two Directories Up")
    } else {
      setwd(here())
      print("Setting to this file")
      
    }
  }
}

# Sets the working directory to the current file, also not really used.
set_working_directory_to_current_file = function () {
  # tryCatch(
  #   expr = {
  #     setwd(getSrcDirectory(function(){})[1])
  #     print(paste("Source Directory",getSrcDirectory(function(){})[1]))
  #   },
  #   error = function(e){ 
  #     print(paste("Not sourcing the file, so trying the RStudio API:  ",e))
  #     setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
  #     print(paste("Running Directory",dirname(rstudioapi::getActiveDocumentContext()$path)))
  #     
  #   })
  print("Setting Working Directory")
  setwd(here())
  
}

# Tests!
test <- function() {
  set_working_directory_to_current_file()
}