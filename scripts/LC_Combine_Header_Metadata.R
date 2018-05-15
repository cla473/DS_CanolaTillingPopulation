#Script to merge Header Information with metadata
rm(list=ls()) #remove existing objects in workspace

#need to look at passing a path (ie "/OSM/CBR/AF_DATASCHOOL/input/Pools_metadata/")
#so that we can set the working directory

#setwd("/OSM/CBR/AF_DATASCHOOL/input/Pools_metadata/") 

library(readxl)
library(tidyverse)

headers <- read.csv("/OSM/CBR/AF_DATASCHOOL/output/metadata/headers.txt", header=T)
metadata <- read.csv("/OSM/CBR/AF_DATASCHOOL/output/metadata/metadata.csv", header=T)

#mod cla473 - merge the data based on the "Pool" number
#             NOTE:  this needs to be a left join on the headers.txt as the metadata may
#                    contain more information than we need
merged.df <- headers %>% 
  left_join(metadata, by="Pool") 


#write_csv("to Pearcey directort.csv) FILL ME IN 
write.csv(merged.df, "/OSM/CBR/AF_DATASCHOOL/output/metadata/combined_data.csv", row.names=FALSE)

