#Script to merge Header Information with metadata

headers <- read.csv("/OSM/CBR/AF_DATASCHOOL/output/metadata/headers.txt", header=T)
#headers <- headers[order(headers$poolNo),]
#df <- cbind(data, headers[,-4])

headers <- read.csv("/OSM/CBR/AF_DATASCHOOL/output/metadata/headers.txt", header=T)
metadata <- read.csv("/OSM/CBR/AF_DATASCHOOL/output/metadata/metadata.csv", header=T)

#mod cla473 - merge the data based on the "Pool" number, and then put data into different order.
df <- merge(data, headers, by="Pool") %>% 
  select (Pool, Plant_ID, Plate_ID, Index, Barcode, Lane_No, Sample_No,
          Gen, Treatment, Date_of_treatment, sowing_date, sequence_platform, 
          sequence_technique, sequence_date, processing_centre, Plant1, 
          Plant2, Plant3, Plant4, Plant5, Plant6, Plant7, Plant8, Plant9,
          Plant10, Plant11, Plant12, Total_Vol, Average_con, 
          Filename, FilenamePath)


#write_csv("to Pearcey directort.csv) FILL ME IN 
write.csv(df, "/OSM/CBR/AF_DATASCHOOL/output/metadata/combined_data.csv", row.names=FALSE)

