###WORK IN PROGRESS###

#Cleaning and preparing metadata file to list which plants are grouped into 
#the 48 pools for sequencing. Collated from: "M2 96 plates.xlsx"

#Still need to confirm:
#1. data of sequencing: there is a date "s.26_02_16" on plate 1 and 2 sheets, but no dates on plates 4-6
#2. Pools originiating from plates 5 and 6 were collated in the same way as the previous plates (not
#   indicated in these sheets)

rm(list=ls()) #remove existing objects in workspace

setwd("~/MGB_docs/Data_School/big_data_prac/") #set relevant working directory
library(readxl)
library(tidyverse)
num_plates<-6 #number of plates in the  experiment
rm(i)
#i<-1

#i<-1 #for trouble shooting
for (i in (1:num_plates)){
  plate<- (read_xlsx("M2 96 plates.xlsx", sheet = paste("plate ",i, sep=""))) #call in the  data and the sheet name (by plate number)
  master<-plate[,1:6] #pull out just the first 6 columns with relevant information
  colnames(master)<-c("Plant_ID","Plate_ID","Plate_Position","Gen" ,"Treatment",
                        "Date_of_treatment") #assigning edited column names for tidyness
  master<-master[-1,] #and deleting the first row that was the headers
  master$Plate_ID<-as.numeric(i) #the plate numbers are formatted differently in different sheets, so re-defing this as numeric and no extras
  master$Date_of_treatment<-as.Date(as.numeric(master$Date_of_treatment), origin = "1899-12-30")
  master$Pool<-rep(((1+((i-1)*8)):(8+((i-1)*8))), 12)  #define the pool number (according to plate number, and A-H = 1-8)
  #assuming  that all plates were pooled in the same way, plate 5 & 6 have no information within sheets
  master$s.date<-rep("s.26_02_16", nrow(master)) #######DATE: TO_BE_CONFIRMED#######
  assign(paste("plate_info",i, sep=""), master) #assign a name to the plate info before returning to top of loop
}
#combine plate information together into a master dataframe (df)
df<-rbind(plate_info1, plate_info2, plate_info3, plate_info4, plate_info5,  plate_info6)
max(df$Pool) #check the desired nuber of pools are present


#make the data tidy according to pool number:
#Couldn't get the spread workin here for the full dataset, so selected just relevant columns, 
#to make wide, andthen bind this plant_ID information onto  the treatment information sheet
df_wide<-df %>%
  mutate(Plate_column = substr(Plate_Position, start = 1, stop = 1))%>%
  mutate(Plate_row = substr(Plate_Position, start = 2, stop = 3))%>%
  select(Pool, Plate_row, Plant_ID)%>%
  group_by(Pool)%>%
  spread(Plate_row, Plant_ID, fill=FALSE)     

#Generate a Pool information sheet
Pool_info<-df%>%
  dplyr::distinct(Pool, .keep_all=TRUE)%>%
  select(-Plate_Position, -Pool)

#bind together & specify column names
plants_in_pools<-cbind(as.data.frame(Pool_info), as.data.frame(df_wide))
colnames(plants_in_pools)<-c("Plant_ID", "Plate_ID", "Gen", "Treatment", "Date_of_treatment", "s.date" ,           
                              "Pool1", "Plant1", "Plant10", "Plant11","Plant12","Plant2", "Plant3", 
                              "Plant4","Plant5","Plant6", "Plant7", "Plant8","Plant9")

#END SCRIPT (FOR NOW)