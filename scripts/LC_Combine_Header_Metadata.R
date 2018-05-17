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
  left_join(metadata, by="Pool") %>% 
  select(Index, Barcode, Lane_No, Pool, Sample_No, Filename, FileNamePath, 
         Sequence_Platform = sequence_platform, 
         Sequence_Technique = sequence_technique, 
         Sequence_Date = sequence_date, 
         Processing_Centre = processing_centre 
  )



#colnames(merged.df)
# Index, Barcode, Lane_No, Pool, Sample_No, Filename, FileNamePath, 
# Plant_ID, Plate_ID, Gen, Treatment, Date_of_treatment, sowing_date, sequence_platform, 
# sequence_technique, sequence_date, processing_centre, 
# Plant1, Plant2, Plant3, Plant4, Plant5, Plant6, Plant7, Plant8, 
# Plant9, Plant10, Plant11, Plant12, Total_Vol, Average_con

#write_csv("to Pearcey directort.csv) FILL ME IN 
write.csv(merged.df, "/OSM/CBR/AF_DATASCHOOL/output/metadata/combined_data.csv", row.names=FALSE)

