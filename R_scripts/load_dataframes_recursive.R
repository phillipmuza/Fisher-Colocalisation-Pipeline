### script to load GFAP, S100B, and S100B+GFAP dataframes recursively 
### Author: Phillip Muza
### Date: 26.10.22

#Path to the load_dataframes.R script
load_dataframes <- "C:\\Users\\phill\\Documents\\Fisher-Colocalisation-Pipeline\\R_scripts\\load_dataframes.R"

#Enter the path to your directory with the folders with your slice data
parent.folder <- "C:\\Users\\phill\\Documents\\CA1"

#This line assigns all the folders within your parent directory to a vector
sub.folders <- list.dirs(parent.folder, recursive = TRUE, full.names = TRUE)

#This is the path to the load_dataframes script
r_script <- file.path(load_dataframes)

#This loop creates merged dataframes from the GFAP, S100B, and Colocalisation dataframes
for (i in sub.folders){
  setwd(i)
  print(i)
  ifelse(file.exists(c("ng2_objects.csv", "s100b_objects.csv", "coloc_objects.csv")),
         source(r_script),
         print("no files found, moving to the next directory"))
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


