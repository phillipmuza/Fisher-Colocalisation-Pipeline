### Script to load csv's of cell counts, volumes, and locations from GFAP, S100B, and S100B+GFAP colocalisations
### Author: Phillip Muza
### Date: 26.10.22

#Load packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse)

#Function to read csv, removes the X column, rename columns, and names of label
format_table <- function(table, label){ 
df <- read.csv(table)
subset_df <- subset(df, select = -c(X))
colnames(subset_df) <- c("Label","Object","Volume(um3)","x-coord","y-coord","z-coord")
levels(subset_df$Label) <- label
return(subset_df)
}

#Read your dataframes
gfap_df <- format_table("gfap_objects.csv", "gfap")
s100b_df <- format_table("s100b_objects.csv", "s100b")
coloc_objects <- format_table("coloc_objects.csv", "coloc")

#Bind the dataframes together by rows 
merged <- rbind(gfap_df, s100b_df, coloc_objects)
write.csv(merged, file = "merged_df.csv")