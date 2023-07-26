### Script to load csv's of cell counts, volumes, and locations from GFAP, S100B, and S100B+GFAP colocalisations
### Author: Phillip Muza
### Date: 26.10.22

####Updated 15.02.23 to include euclidean distances between S100B objects and S100B+GFAP+ objects
  #S100B+ objects colocalised with GFAP+ are considered to have euclidean distances <15 between them.

#Load packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, plyr)

#Function to read csv, removes the X column, rename columns, and names of label
format_table <- function(table, label){ 
df <- read.csv(table, fileEncoding="Latin1")
subset_df <- subset(df, select = -c(X))
colnames(subset_df) <- c("Label","Object","Volume(um3)","x-coord","y-coord","z-coord")
levels(subset_df$Label) <- label
return(subset_df)
}

#Function to calculcate the euclidean distance
euclidean_distance <- function(df1, df2){ #df1 is your reference dataframe
  df1$euclidean_distance <- 0
  for (i in 1:nrow(df1)){
    #This for loop take a row from your Df1 and calculates the euclidean distance to every other row in your Df2 and assigns it to a vector
    eucl_values <- mutate(df2, eucl_dist = sqrt((df1[i,]$`x-coord` - `x-coord`)^2 +
                                                  (df1[i,]$`y-coord` - `y-coord`)^2 +
                                                  (df1[i,]$`z-coord` - `z-coord`)^2)) %>% pull(eucl_dist)
    min_distance <- min(eucl_values)
    df1[i,]$euclidean_distance <- min_distance
  }
  return(df1)
}

#Read your dataframes
ng2_df <- format_table("ng2_objects.csv", "NG2")
s100b_df <- format_table("s100b_objects.csv", "S100B")
coloc_objects <- format_table("coloc_objects.csv", "coloc")

#S100B objects with a euclidean distance <15 to colocalised objects (coloc) are considered to be S100B+NG2+
  #S100B objects are considered the main cell type, as they should be more numerous than NG2+ cells 
    #The euclidean distances should be calculated from the cell type you expect to be more abundant 
s100b_df <- euclidean_distance(s100b_df, coloc_objects)
s100b_df <- s100b_df %>% mutate(NG2_colocalisation = 
                 case_when(euclidean_distance >= 15 ~ "NG2-",
                           euclidean_distance < 15 ~ "NG2+"))

#Bind the dataframes together by rows 
merged <- plyr::rbind.fill(ng2_df, s100b_df)
write.csv(merged, file = "merged_df.csv")