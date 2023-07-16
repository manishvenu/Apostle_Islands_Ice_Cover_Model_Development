
# Description:
# This function downloads ice data by year from GLERL (Great Lakes Environmental Research Lab). It then checks and unzips the data. It is very slow!!
# Parameters:
#   1. Ice_Year_Vector: For what years do we want to download ice data for
#   2. data_dir: Where do you put the downloaded data
# Returns:
#   Nothing!
download_ice_cover_data_by_year <- function(ice_year_vector,data_dir) {
  download_link_url_start = "https://www.glerl.noaa.gov/data/ice/glicd/grids/grid"
  
  
  ## Check if zip repo exists and create one##
  zip_repo = file.path(data_dir,"ZipRepository")
  if (!dir.exists(zip_repo)) {
    dir.create(zip_repo)
  }
  
  for (year in ice_year_vector) {
    
    ## Create Download Link ##
    download_link = paste0(download_link_url_start,year,".zip")
    
    ## Create place file will go to ##
    
    
    file_end_path = file.path(zip_repo, basename(download_link))
    
    ## Check if Zip File Exists ##
    if (!file.exists(file_end_path)) {
      
      ## Download zip file if not found ##
      print(paste0("Downloading...",download_link))
      download.file(download_link, file_end_path)
    } else {
      print(paste("Found zip file for",year))
    }
    
    ## Check if output directory exists and create it ##
    output_zip_files = file.path(data_dir,paste0("grid",year))
    if (!dir.exists(output_zip_files)) {
      dir.create(output_zip_files)
    }
    
    ## List files in zip archive to verify if exist ##
    list_zip_files = unzip(zipfile = file_end_path, list = TRUE)
    all_files_found = TRUE
    for (file in list_zip_files$Name) {
      if (!file.exists(file.path(output_zip_files,file))) {
        all_files_found = FALSE
        print(paste0("Missing File: ",file))
        break
      }
    }
    ## If not all files exist, unzip the file ##
    if (!all_files_found) {
      output_text = paste0("Unzipping zip archive from ",list_zip_files$Name[1]," to ",list_zip_files$Name[length(list_zip_files$Name)]," (takes a long time)....")
      print(output_text)
      unzip(zipfile = file_end_path, exdir = output_zip_files, overwrite = FALSE)
    }
    print("Successfully finished downloading theyearly  data")
  }
  print("Successfully Finished Downloading ALL Data")
  
}

# This function created an "IceCoverData" folder if it doesn't already exist.
create_ice_cover_data_folder<- function() {
  print("Creating Ice Cover Data Folder")
  if (!dir.exists("Data/IceCoverData")) {
    dir.create("Data/IceCoverData")
  }
  
  data_dir = "Data/IceCoverData"
  return(data_dir)
}
#Test: download_ice_cover_data_by_year(c(2019),"Data/IceCoverData")

