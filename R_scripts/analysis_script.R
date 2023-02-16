### Script file for data analysis of GFAP+S100B Colocalisation
  ### Updated so its more concise - 15.02.23
### Author: Phillip Muza
### Date: 26.01.23

###Change according to your experimental needs

#### Load packages and functions #### 
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse)

#Read your merged dataframes and volume table and combine them together
read_dataframes <- function(){
  cells_df = list.files(pattern = "*merged.csv", ignore.case = TRUE)
  volume_df = list.files(pattern = "AllPixels.txt", ignore.case = TRUE)
  df <- read.csv(cells_df) #reads merged_df.csv
  vol <- read.table(volume_df, header = F) #reads AllPixels.txt
  colnames(vol) <- c("x", "y", "z", "pixel_values")
  voxel_size <- length(vol$x) * (2^3) #voxel size is X^3 where X=z-step size (or downsampling factor)
  volume <- voxel_size / (1000^3) #volume = mm^3 
  df$region_volume.mm3. <- volume #Add volume to the decode_dataframe
  return(df)
}

#This for loop will go through each parent directory and sub-directory and generate a list of dataframes
read_dataframes_loop <- function(){
  dataframes = list() #Initialise an empty list to store your dataframes
  for (parent in parent_directories){
    setwd(parent)
    print(parent)
    decoded <- subset(animal_decoded, blinded_number == basename(getwd())) #decoded table for the given folder/animal
    sub_directories = list.dirs(getwd(), full.names = TRUE) #loop through subfolders in your parent directory
    for (sub in sub_directories){
      setwd(sub)
      print(sub)
      if (file.exists("AllPixels.txt")){ #if else statement to allow us to escape any empty folders 
        df <- read_dataframes() #read your cell table and volume tables 
        df2 <- cbind(df, decoded) #combine your cell and volume dataframes with your decoded dataframe for the given folder/animal
        dataframes[[sub]] <- df2 #append df2 into your dataframes list
      } else {
        print("No AllPixels.txt found, moving to the next directory")
      }
    }
  }
  return(dataframes)
}

#Tidy your dataframe using this function
clean_dataframe <- function(){
  combined_data <- bind_rows(list_of_dataframes)
  combined_data$GFAP_colocalisation <- as.character(combined_data$GFAP_colocalisation)
  combined_data[is.na(combined_data)] <-""
  combined_data$markers <- paste(combined_data$Label, combined_data$GFAP_colocalisation, sep = "+")
  combined_data <- subset(combined_data, select = -c(Label, GFAP_colocalisation))
  remove_columns_df <- subset(combined_data, select = c(markers, Object, Volume.um3.,
                                                        region_volume.mm3., cage, 
                                                        age, sex, genotype, 
                                                        blinded_number))
  cleaned_dataframe <- remove_columns_df[, c("blinded_number", "genotype", "sex",
                                             "cage", "age", "markers", "Object",
                                             "region_volume.mm3.", "Volume.um3.")]
  return(cleaned_dataframe)
}

#Summarise and group data 
summarise_dataframe <- function(){
  summary_df <- clean_df %>%
    group_by(blinded_number, genotype, brain_region, sex, markers) %>%
    summarise(objects = n(),
              mean_region_volume.mm3. = mean(region_volume.mm3.),
              mean_cell_volume = mean(Volume.um3.),
              total_volume.mm3. = sum(Volume.um3.) / (1000^3)
    )
  summary_df$cell_density.cells.mm3. <- summary_df$objects * summary_df$mean_region_volume.mm3.
  summary_df$cell_coverage.100percent. <- (summary_df$total_volume.mm3. / summary_df$mean_region_volume.mm3.) * 100
  return(summary_df)
}

#### Run your script from here ####

#1. Set Working Directory
setwd("S:\\IoN_Fisher_Lab\\Phillip\\Immunohistochemistry\\s100b_gfap\\coloc_analysis\\ML_PML")

#2. Upload your table with your decoded data
animal_decoded <- read.csv("../../blinded_df.csv")

#Set up a variable for your parent folders
  #We will loop through these to decode and set up our big dataframe
parent_directories = list.dirs(getwd(), full.names = TRUE, recursive = FALSE)

#3.Generate your dataframes
list_of_dataframes <- read_dataframes_loop()

#4.Tidy your list of dataframes
clean_df <- clean_dataframe()

#You can add a column describing your brain region - replace "CA1" with the description
clean_df$brain_region <- "CA1"

#5.Summarise and group your data
summarised_df <- summarise_dataframe()

#6. Build your dataset 
  ## NOT RUN ##
#CA1_clean <- summarise_dataframe()
#CA3_clean <- summarise_dataframe()
#GCL_clean <- summarise_dataframe()
#ML_PML_clean <- summarise_dataframe()

summarised_dataset <- rbind(CA1_clean, CA3_clean, GCL_clean, ML_PML_clean)

#CA1_long <- clean_df
#CA3_long <- clean_df
#GCL_long <- clean_df
#ML_PML_long <- clean_df

raw_dataset <- rbind(CA1_long, CA3_long, GCL_long, ML_PML_long)
  