### Script file for data analysis of GFAP+S100B Colocalisation
### Author: Phillip Muza
### Date: 26.10.22

##This is an example (poorly done example...) of how to quantify the colocalisation data
  ###Change according to your experimental needs

#Load packages 
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse)

#Set Working Directory
setwd("S:\\IoN_Fisher_Lab\\Phillip\\Immunohistochemistry\\s100b_gfap\\DG")

#Function to make a DF of your decoded animals
animal_decoded <- function(genotype, AN_number, animal_sex){
  df <- data.frame(genotype = genotype,
                   animal_number = AN_number,
                   sex = animal_sex 
                   )
  return(df)
}

#IMPORTANT: this function will read your merged_df, and ALLPixels.txt, and assign it to your decoded dataframe
  #Make sure you are happy with this function before moving on
read_data <- function(dataframe, decoded_dataframe, vol_df){
  df <- read.csv(dataframe) #reads merged_df.csv
  decode_dataframe<- cbind(df, decoded_dataframe) #merges merged_df to decoded_dataframe
  vol <- read.table(vol_df, header =F) #reads AllPixels.txt
  colnames(vol) <- c("x", "y", "z", "pixel_values")
  voxel_size <- length(vol$x) * (2^3) #voxel size is X^3 where X=z-step size (or downsampling factor)
  volume <- voxel_size / (1000^3) #volume == mm^3 
  decode_dataframe$region_volume.mm3. <- volume #Add volume to the decode_dataframe
  return(decode_dataframe) #This is the final DF for a given image
}

##Add your decoded dataframes here

#AN1_dec <- animal_decoded("Dp2Yey", "AN1", "female")
AN2_dec <- animal_decoded("Dp2Yey", "AN2", "male")
AN3_dec <- animal_decoded("WT", "AN3", "female")
AN4_dec <- animal_decoded("Dp2Yey", "AN4", "male")
AN5_dec <- animal_decoded("Dp2Yey", "AN5", "female")
AN6_dec <- animal_decoded("Dp2Yey", "AN6", "female")
AN7_dec <- animal_decoded("WT", "AN7", "male")
AN8_dec <- animal_decoded("Dp2Yey", "AN8", "female")
AN9_dec <- animal_decoded("Dp2Yey", "AN9", "male")
AN10_dec <- animal_decoded("WT", "AN10", "female")
AN11_dec <- animal_decoded("WT", "AN11", "female")
AN12_dec <- animal_decoded("WT", "AN12", "male")
AN13_dec <- animal_decoded("Dp2Yey", "AN13", "female")
AN15_dec <- animal_decoded("WT", "AN15", "male")
#AN16_dec <- animal_decoded("Dp2Yey", "AN16", "male")
AN17_dec <- animal_decoded("WT", "AN17", "female")
AN18_dec <- animal_decoded("WT", "AN18", "male")
AN19_dec <- animal_decoded("Dp2Yey", "AN19", "male")
AN20_dec <- animal_decoded("WT", "AN20", "male")

#Add your dataframes for each indiviudal image
  ##NOTE TO SELF: MAKE THIS LESS REPETITIVE (think about using across and assign)

#raw_AN1 <- read_data("AN1/an1_merged.csv", AN1_dec, "an1/AllPixels.txt")
raw_AN2_A <- read_data("AN2/img_A/img_A_merged.csv", AN2_dec, "an2/img_A/AllPixels.txt") 
raw_AN2_B <- read_data("AN2/img_B/img_B_merged.csv", AN2_dec, "an2/img_B/AllPixels.txt")
raw_AN2_C <- read_data("AN2/img_C/img_C_merged.csv", AN2_dec, "an2/img_C/AllPixels.txt")
raw_AN3_A <-read_data("AN3/img_A/img_A_merged.csv", AN3_dec, "an3/img_A/AllPixels.txt")
raw_AN3_B <-read_data("AN3/img_B/img_B_merged.csv", AN3_dec, "an3/img_B/AllPixels.txt")
raw_AN3_C <-read_data("AN3/img_C/img_C_merged.csv", AN3_dec, "an3/img_C/AllPixels.txt")
raw_AN4_A <-read_data("AN4/img_A/img_A_merged.csv", AN4_dec, "an4/img_A/AllPixels.txt")
raw_AN4_B <-read_data("AN4/img_B/img_B_merged.csv", AN4_dec, "an4/img_B/AllPixels.txt")
raw_AN4_C <-read_data("AN4/img_C/img_C_merged.csv", AN4_dec, "an4/img_C/AllPixels.txt")
raw_AN5 <-read_data("AN5/an5_merged.csv", AN5_dec, "an5/AllPixels.txt")
raw_AN6_A <-read_data("AN6/img_A/img_A_merged.csv", AN6_dec, "an6/img_A/AllPixels.txt")
raw_AN6_B <-read_data("AN6/img_B/img_B_merged.csv", AN6_dec, "an6/img_B/AllPixels.txt")
raw_AN7_A <-read_data("AN7/img_A/img_A_merged.csv", AN7_dec, "an7/img_A/AllPixels.txt")
raw_AN7_B <-read_data("AN7/img_B/img_B_merged.csv", AN7_dec, "an7/img_B/AllPixels.txt")
raw_AN7_C <- read_data("AN7/img_C/img_C_merged.csv", AN7_dec, "an7/img_C/AllPixels.txt")
raw_AN8_A <-read_data("AN8/img_A/img_A_merged.csv", AN8_dec, "an8/img_A/AllPixels.txt")
raw_AN8_B <-read_data("AN8/img_B/img_B_merged.csv", AN8_dec, "an8/img_B/AllPixels.txt")
raw_AN8_C <-read_data("AN8/img_C/img_C_merged.csv", AN8_dec, "an8/img_C/AllPixels.txt")
raw_AN9_A <-read_data("AN9/img_A/img_A_merged.csv", AN9_dec, "an9/img_A/AllPixels.txt")
raw_AN9_B <-read_data("AN9/img_B/img_B_merged.csv", AN9_dec, "an9/img_B/AllPixels.txt")
raw_AN9_C <-read_data("AN9/img_C/img_C_merged.csv", AN9_dec, "an9/img_C/AllPixels.txt")
raw_AN10_A <-read_data("AN10/img_A/img_A_merged.csv", AN10_dec, "an10/img_A/AllPixels.txt")
raw_AN10_B <-read_data("AN10/img_B/img_B_merged.csv", AN10_dec, "an10/img_B/AllPixels.txt")
raw_AN10_C <-read_data("AN10/img_C/img_C_merged.csv", AN10_dec, "an10/img_C/AllPixels.txt")
raw_AN11_A <-read_data("AN11/img_A/img_A_merged.csv", AN11_dec, "an11/img_A/AllPixels.txt")
raw_AN11_B <-read_data("AN11/img_B/img_B_merged.csv", AN11_dec, "an11/img_B/AllPixels.txt")
raw_AN12_A <-read_data("AN12/img_A/img_A_merged.csv", AN12_dec, "an12/img_A/AllPixels.txt")
raw_AN12_B <-read_data("AN12/img_B/img_B_merged.csv", AN12_dec, "an12/img_B/AllPixels.txt")
raw_AN12_C <-read_data("AN12/img_C/img_C_merged.csv", AN12_dec, "an12/img_C/AllPixels.txt")
raw_AN13_A <-read_data("AN13/img_A/img_A_merged.csv", AN13_dec, "an13/img_A/AllPixels.txt")
raw_AN13_B <-read_data("AN13/img_B/img_B_merged.csv", AN13_dec, "an13/img_B/AllPixels.txt")
raw_AN13_C <- read_data("AN13/img_C/img_C_merged.csv", AN13_dec, "an13/img_C/AllPixels.txt")
raw_AN15_A <-read_data("AN15/img_A/img_A_merged.csv", AN15_dec, "an15/img_A/AllPixels.txt")
raw_AN15_B <-read_data("AN15/img_B/img_B_merged.csv", AN15_dec, "an15/img_B/AllPixels.txt")
raw_AN15_C <-read_data("AN15/img_C/img_C_merged.csv", AN15_dec, "an15/img_C/AllPixels.txt")
#raw_AN16 <-read_data("AN16/an16_merged.csv", AN16_dec, "an16/AllPixels.txt")
raw_AN17_A <-read_data("AN17/img_A/img_A_merged.csv", AN17_dec, "an17/img_A/AllPixels.txt")
raw_AN17_B <-read_data("AN17/img_B/img_B_merged.csv", AN17_dec, "an17/img_B/AllPixels.txt")
raw_AN18_A <-read_data("AN18/img_A/img_A_merged.csv", AN18_dec, "an18/img_A/AllPixels.txt")
raw_AN18_B <-read_data("AN18/img_B/img_B_merged.csv", AN18_dec, "an18/img_B/AllPixels.txt")
raw_AN18_C <-read_data("AN18/img_C/img_C_merged.csv", AN18_dec, "an18/img_C/AllPixels.txt")
raw_AN19_A <-read_data("AN19/img_A/img_A_merged.csv", AN19_dec, "an19/img_A/AllPixels.txt")
raw_AN19_B <-read_data("AN19/img_B/img_B_merged.csv", AN19_dec, "an19/img_B/AllPixels.txt")
raw_AN19_C <-read_data("AN19/img_C/img_C_merged.csv", AN19_dec, "an19/img_C/AllPixels.txt")
raw_AN20_B <-read_data("AN20/img_B/img_B_merged.csv", AN20_dec, "an20/img_B/AllPixels.txt")
raw_AN20_C <-read_data("AN20/img_C/img_C_merged.csv", AN20_dec, "an20/img_C/AllPixels.txt")

#Remove decoded dataframes to tidy the global environment
rm(list = ls(pattern = "_dec", envir = .GlobalEnv))

#IMPORTANT - this function will run your final calculations by taking the means for all images for a given animal
  ##Bind Cell Counts and calculate proportions of cells
binding_cellCounts <- function(...){
  bound_df <- rbind(...)
  summary_df <- bound_df %>%
    group_by(Label, genotype, animal_number, sex) %>%
    summarise(objects = n(),
              mean_region_volume.mm3. = mean(region_volume.mm3.),
              mean_cell_volume = mean(Volume.um3.), 
              total_volume.mm3. = sum(Volume.um3.) / (1000^3)
    ) 
  df <- summary_df %>%
    pivot_wider(names_from = Label, values_from = c("objects", "mean_region_volume.mm3.", "mean_cell_volume", "total_volume.mm3."))
  df$mean_ROI_volume.mm3. <- mean(df$mean_region_volume.mm3._coloc, df$mean_region_volume.mm3._gfap, df$mean_region_volume.mm3._s100b)
  df <- subset(df, select = -c(mean_region_volume.mm3._gfap, mean_region_volume.mm3._coloc, mean_region_volume.mm3._s100b))
  df$s100b_cellDensity.cells.mm3. <- df$objects_s100b * df$mean_ROI_volume.mm3.
  df$coloc_cellDensity.cells.mm3. <- df$objects_coloc * df$mean_ROI_volume.mm3.
  df$gfap_coverage.100percent. <- (df$total_volume.mm3._gfap / df$mean_ROI_volume.mm3.) * 100
  df$s100b_coverage.100percent. <- (df$total_volume.mm3._s100b / df$mean_ROI_volume.mm3.) * 100
  colnames(df)[7:17] <- c("coloc_cell_volume(um^3)","gfap_cell_volume(um^3)","s100b_cell_volume(um^3)", 
                                  "coloc_total_volume(mm^3)","gfap_total_volume(mm^3)","s100b_total_volume(mm^3)",
                                  "mean_ROI_volume(mm^3)",
                                  "s100b_CellDensity(cells/mm^3)","coloc_CellDensity(cells/mm^3)",
                                  "gfap_coverage(%)","s100b_coverage(%)")
  return(df)
}


#AN1_counts <- binding_cellCounts(raw_AN1)
AN2_counts <- binding_cellCounts(raw_AN2_A, raw_AN2_B, raw_AN2_C)
AN3_counts <- binding_cellCounts(raw_AN3_A, raw_AN3_B, raw_AN3_C)
AN4_counts <- binding_cellCounts(raw_AN4_A, raw_AN4_B, raw_AN4_C)
AN5_counts <- binding_cellCounts(raw_AN5)
AN6_counts <- binding_cellCounts(raw_AN6_A, raw_AN6_B)
AN7_counts <- binding_cellCounts(raw_AN7_A, raw_AN7_B, raw_AN7_C)
AN8_counts <- binding_cellCounts(raw_AN8_A, raw_AN8_B, raw_AN8_C)
AN9_counts <- binding_cellCounts(raw_AN9_A, raw_AN9_B, raw_AN9_C)
AN10_counts <- binding_cellCounts(raw_AN10_A, raw_AN10_B, raw_AN10_C)
AN11_counts <- binding_cellCounts(raw_AN11_A, raw_AN11_B)
AN12_counts <- binding_cellCounts(raw_AN12_A, raw_AN12_B, raw_AN12_C)
AN13_counts <- binding_cellCounts(raw_AN13_A, raw_AN13_B, raw_AN13_C)
AN15_counts <- binding_cellCounts(raw_AN15_A, raw_AN15_B, raw_AN15_C)
#AN16_counts <- binding_cellCounts(raw_AN16)
AN17_counts <- binding_cellCounts(raw_AN17_A, raw_AN17_B)
AN18_counts <- binding_cellCounts(raw_AN18_A, raw_AN18_B, raw_AN18_C)
AN19_counts <- binding_cellCounts(raw_AN19_A, raw_AN19_B, raw_AN19_C)
AN20_counts <- binding_cellCounts(raw_AN20_B, raw_AN20_C)

#Data Analysis
summary_counts <- do.call(rbind, mget(ls(pattern="_counts"), envir = .GlobalEnv)) #combine all dataframes
write.csv(summary_counts, file = "summary_counts.csv") #save combined dataframes

