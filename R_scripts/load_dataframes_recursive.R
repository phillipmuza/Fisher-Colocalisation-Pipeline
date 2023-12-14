### script to load GFAP, S100B, and S100B+GFAP dataframes recursively 
### Author: Phillip Muza
### Date: 26.10.22

###UPDATE: Including warning and error statements + ease of running the script

#Name of the reference image - i.e. the cell type which you will assay your colocalisations against
reference_cell_type = 'S100B'
name_of_reference_image = 's100b_objects.csv'

#Name of the test image - i.e. the cell type which is assayed against the reference image
test_cell_type = 'GFAP'
name_of_test_image = 'gfap_objects.csv'

#Path to the load_dataframes.R script
load_dataframes <- "C:\\Users\\phill\\OneDrive\\Documents\\colocalisations_glia\\Fisher-Colocalisation-Pipeline\\R_scripts\\load_dataframes.R"

#Enter the path to your directory with the folders with your slice data
parent.folder <- "C:\\Users\\phill\\OneDrive\\Documents\\colocalisations_glia\\coloc_analysis\\CA1"

#This line assigns all the folders within your parent directory to a vector
sub.folders <- list.dirs(parent.folder, recursive = TRUE, full.names = TRUE)

#This is the path to the load_dataframes script
r_script <- file.path(load_dataframes)

#This loop creates merged dataframes from the GFAP, S100B, and Colocalisation dataframes
for (i in sub.folders){
  setwd(i)
  cat(crayon::blue('Now working in:', i, '\n'))
  files_needed <- list(name_of_reference_image, name_of_test_image, "coloc_objects.csv") #this are the files required to run this function
  
  #this for statement catches any missing files within your WD and stops the function if files are missing
  for (files in files_needed){
    if(!file.exists(files)){
      cat(crayon::bgRed(files, 'is missing. Please re-run:', getwd(), '\n')) 
      next
    } else {source(r_script)}
  }
}

#This loop will rename those merged files into something unique to that particular folder
for (d in sub.folders){
  setwd(d)
  print(d)
  if (file.exists("merged_df.csv")){
    filename <- basename(d)
    file.rename("merged_df.csv", paste0(filename, "_merged.csv"))
  } else {
    print("no file found")
  }
}


