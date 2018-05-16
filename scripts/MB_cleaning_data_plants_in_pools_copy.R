###WORK IN PROGRESS###

#Cleaning and preparing metadata file to list which plants are grouped into 
#the 48 pools for sequencing, as well as informration on the sequencing procedure
#for each pool. 

#Data collated from: "M2 seeds grids to soil and scoring of phenotypes"; "M2 96 plates.xlsx"; 
#"160725_Canola_Plate_1"; "160726plate2"; "160726plate3"; "160726plate4"; "RESULTS PLATE 5 161128"; 
#"RESULTS PLATE 6 161129"

#sequencing information from Chris Helliwell (chris.helliwell@csiro.au)

#Still need to confirm:
#1. That the pools originiating from plates 5 and 6 were collated in the same way as the previous plates 
#(not indicated in these sheets)



#rm(list=ls()) #remove existing objects in workspace
#setwd("/OSM/CBR/AF_DATASCHOOL/input/Pools_metadata/") #set relevant working directory - local copy for analysis
library(readxl)
library(tidyverse)

#sowing date was recorded in the "ALL" sheet of "M2 seeds grids to soil and scoring of phenotypes"
#extract this date before starting the loop (there are 10 plates in this file)
ALL<- read_xlsx("/OSM/CBR/AF_DATASCHOOL/input/Pools_metadata/M2 seeds grids to soil and scoring of phenotypes.xlsx", sheet = "ALL")
sowing_date<-ALL%>%
  select('plate #', planted)%>%
  distinct(planted)%>% #pull out only the first line of each plate (assuming these are all the same)
  na.omit() #the first line is a blank, so remove


#Defining Metadata for Header file: confrimed from discussion with Chris Helliwell
sequence_date<-c("TBA", "TBA", "TBA", "TBA", "TBA", "TBA")#according to plate number
sequence_platform<-"Illumina" 
sequence_technique<-c("HiSeq","HiSeq","HiSeq","NextSeq","NextSeq","NextSeq") #according to plate number
processing_centre<-"ACRF Biomolecular Resource Facility - John_Curtin"


num_plates<-6 #number of plates that were sequenced
#i<-1 #for trouble shooting
#rm(i) #remove i if needed

for (i in (1:num_plates)){
  plate<- (read_xlsx("/OSM/CBR/AF_DATASCHOOL/input/Pools_metadata/M2 96 plates.xlsx", sheet = paste("plate ",i, sep=""))) #call in the  data and the sheet name (by plate number)
  master<-plate[,1:6] #pull out just the first 6 columns with relevant information, rename this "master" dataframe
  colnames(master)<-c("Plant_ID","Plate_ID","Plate_Position","Gen" ,"Treatment",
                        "Date_of_treatment") #assigning edited column names for tidyness
  master<-master[-1,] #and deleting the first row that had the headers in it
  master$Plate_ID<-as.numeric(i) #the plate numbers are formatted differently in different sheets, so re-defing this as numeric
  master$Date_of_treatment<-as.Date(as.numeric(master$Date_of_treatment), origin = "1899-12-30") #Translating  the annoying excel number 
  #date formatting to an R formated type, this conforms with the original excel sheets (but check in any future runs)
  master$Pool<-rep(((1+((i-1)*8)):(8+((i-1)*8))), 12)  #define the pool number (according to plate number, and A-H = pools 1-8)
  #here assuming that all plates were pooled in the same way, plate 5 & 6 have no information within sheets
  master$sowing_date<-rep(sowing_date[i,],12) #keep the formatting as is for now... may need editing later  on
  
  master$sequence_platform<-sequence_platform
  master$sequence_technique<-sequence_technique[i]
  master$sequence_date<-sequence_date[i]
  master$processing_centre<-processing_centre
  
  assign(paste("plate_info",i, sep=""), master) #assign a name to the plate info before returning to top of loop
}
#combine plate information together into a master dataframe (df)
df<-rbind(plate_info1, plate_info2, plate_info3, plate_info4, plate_info5,  plate_info6)
max(df$Pool) #check the desired number of pools are present


#make the data tidy, where pool number is the unique experimental unit:
#Couldn't get the "spread" working here for the full dataset, so selected just relevant columns, 
#to make wide, and then bind this "plant_ID" information onto the treatment information sheet
df_wide<-df %>%
  mutate(Plate_column = substr(Plate_Position, start = 1, stop = 1))%>% #define the plate columnes (A-H)
  mutate(Plate_row = substr(Plate_Position, start = 2, stop = 3))%>% #define the plate rows (1-12)
  select(Pool, Plate_row, Plant_ID)%>% #select the Pool, plate row and plant ID data onle
  group_by(Pool)%>% #group by the pool (1-48)
  spread(Plate_row, Plant_ID, fill=FALSE)   #spread plants in each plate_row (pool), across the data frame  
colnames(df_wide)<-c("Pool", "Plant1", "Plant10", "Plant11", "Plant12", "Plant2", "Plant3", 
                     "Plant4", "Plant5", "Plant6", "Plant7", "Plant8", "Plant9")
#Generate a Pool information sheet
Pool_info<-df%>%
  dplyr::distinct(Pool, .keep_all=TRUE)%>% #for the information columns, keep only  one row per pool (so 48 rows only)
  select(-Plate_Position, -Pool) #remove the redundant columns

#bind together the plate information and plant_IDs (df_wide) & specify column names
plants_in_pools<-cbind(as.data.frame(df_wide$Pool), as.data.frame(Pool_info), as.data.frame(df_wide[,2:ncol(df_wide)]))
colnames(plants_in_pools)[1]<-"Pool"

### Call in other spreadsheets to collate average concentrations across the 12 plants in each pool, 
#and total volume in each pool 
##These data are formatted differently depending on each plate's file, so need to treat each data
#file and sheet separatly, then bind all together at the end.
filenames<-c("160725_Canola_Plate_1","160726plate2",
             "160726plate3","160726plate4","RESULTS PLATE 5 161128","RESULTS PLATE 6 161129")
sheetnames<-c("160725", "160726plate2", "160726plate3", "160726plate4", 
              "RESULTS PLATE 5 161128", "RESULTS PLATE 6 161129")
#Plate1
plate1<-read_xlsx(paste("/OSM/CBR/AF_DATASCHOOL/input/Pools_metadata/",filenames[1],".xlsx", sep=""), sheet=sheetnames[1])
Plate1_vol<-as.numeric(plate1$X__12[seq(54,68,2)])
Plate1_con<-as.numeric(plate1$X__12[seq(35,49,2)])
plate1_vol_con<-as.data.frame(cbind(seq(1,8,1),Plate1_vol, Plate1_con ))
colnames(plate1_vol_con)<-c("Pool", "Total_Vol", "Average_con")

#Plate2
plate2<-read_xlsx(paste("/OSM/CBR/AF_DATASCHOOL/input/Pools_metadata/",filenames[2],".xlsx", sep=""), sheet=sheetnames[2],col_names = FALSE)
Plate2_vol<-as.numeric(plate2$X__14[seq(64,78,2)])
#need to calculate average concentration for the individuals wells to get pooled con
Plate2_con<-as.data.frame(lapply(plate2[seq(45,59,2), 1:12], as.numeric))
plate2_vol_con<-as.data.frame(cbind(seq((1+8),(8+8), 1),Plate2_vol, rowMeans(Plate2_con)))
colnames(plate2_vol_con)<-colnames(plate1_vol_con)

#Plate3
plate3<-read_xlsx(paste("/OSM/CBR/AF_DATASCHOOL/input/Pools_metadata/",filenames[3],".xlsx", sep=""), sheet=sheetnames[3],col_names = FALSE)
Plate3_vol<-as.numeric(plate3$X__14[seq(65,79,2)])
#need to calculate average concentration for the individuals wells to get pooled con
Plate3_con<-as.data.frame(lapply(plate3[seq(46,60,2), 1:12], as.numeric))
plate3_vol_con<-as.data.frame(cbind(seq((1+2*8),(8+2*8), 1),Plate3_vol, rowMeans(Plate3_con)))
colnames(plate3_vol_con)<-colnames(plate1_vol_con)

#Plate4
plate4<-read_xlsx(paste("/OSM/CBR/AF_DATASCHOOL/input/Pools_metadata/",filenames[4],".xlsx", sep=""), sheet=sheetnames[4],col_names = FALSE)
Plate4_vol<-as.numeric(plate4$X__14[seq(63,77,2)])
#need to calculate average concentration for the individuals wells to get pooled con
Plate4_con<-as.data.frame(lapply(plate4[seq(45,59,2), 1:12], as.numeric))
plate4_vol_con<-as.data.frame(cbind(seq((1+3*8),(8+3*8), 1), Plate4_vol, rowMeans(Plate4_con)))
colnames(plate4_vol_con)<-colnames(plate1_vol_con)

#Plates 5 and 6 are summarised at top of files: ###COULD NOT FIND CONCENTRATIONS FOR PLATES 5 & 6
plate5<-read_xlsx(paste("/OSM/CBR/AF_DATASCHOOL/input/Pools_metadata/",filenames[5],".xlsx", sep=""), sheet=sheetnames[5])
Plate5_vol<-plate5[1:8, 18]
plate5_vol_con<-cbind(seq((1+4*8),(8+4*8), 1),Plate5_vol, rep("NA", 8))
colnames(plate5_vol_con)<-colnames(plate1_vol_con)

plate6<-read_xlsx(paste("/OSM/CBR/AF_DATASCHOOL/input/Pools_metadata/",filenames[6],".xlsx", sep=""), sheet=sheetnames[6],col_names = FALSE)
Plate6_vol<-plate6[1:8, 20]
plate6_vol_con<-cbind(seq((1+5*8),(8+5*8), 1), Plate6_vol, rep("NA", 8))
colnames(plate6_vol_con)<-colnames(plate1_vol_con)

pool_contents<-rbind(plate1_vol_con, plate2_vol_con, plate3_vol_con,
                 plate4_vol_con, plate5_vol_con, plate6_vol_con)


#Combine these volumes and concentrations with the plants_in_pools data from above

plants_in_pools<-cbind(plants_in_pools, pool_contents[,2:3])
head(plants_in_pools) #check all looks ok


data <- as.data.frame(plants_in_pools[c(1:12,16:23,13:15,24:25)])# -- changes column order has plants in sequence
# PW - 20180518
## At this stage, data[,7] is seen as a list, and is not directly writable as a CSV
## Need to delist and will remove leading two chars from string - "s."
## Substitute '.' with '-' and reformat.

data[,7] <- as.Date(gsub("\\.","-",substr(unlist(data[,7]), 3, nchar(data[,7]))), "%d-%m-%y")

headers <- read.csv("../metadata/headers.txt", header=T)
headers <- headers[order(headers$poolNo),]

df <- cbind(data, headers[,-4])

#write_csv("to Pearcey directort.csv) FILL ME IN 
write_csv(df, "/OSM/CBR/AF_DATASCHOOL/output/metadata/combined_data.csv")

#END SCRIPT (FOR NOW)