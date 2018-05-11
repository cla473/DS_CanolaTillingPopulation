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
#sowing date was written in the "ALL" sheet of "M2 seeds grids to soil and scoring of phenotypes"
#extract before starting the loop (there are 10 plates in this file.. )
ALL<- read_xlsx("M2 seeds grids to soil and scoring of phenotypes.xlsx", sheet = "ALL") #call in the  data and the sheet name (by plate number)
sowing_date<-ALL%>%
  select('plate #', planted)%>%
  distinct(planted)%>%
  na.omit()

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
  master$s.date<-rep(sowing_date[i,],12 )
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



### CALL in other spreadsheets to colalte average concentrations across the 12 plants in the 
#combined pools, and total volumn in each pool 
##These data are formatted differently depending on each plate's file, so need to treat each data
#file and sheet separatly, then bind at the end.
filenames<-c("160725_Canola_Plate_1","160726plate2",
             "160726plate3","160726plate4","RESULTS PLATE 5 161128","RESULTS PLATE 6 161129")
sheetnames<-c("160725", "160726plate2", "160726plate3", "160726plate4", 
              "RESULTS PLATE 5 161128", "RESULTS PLATE 6 161129")
#Plate1
plate1<-read_xlsx(paste(filenames[1],".xlsx", sep=""), sheet=sheetnames[1])
Plate1_vol<-as.numeric(plate1$X__12[seq(54,68,2)])
Plate1_con<-as.numeric(plate1$X__12[seq(35,49,2)])
plate1_vol_con<-as.data.frame(cbind(seq(1,8,1),Plate1_vol, Plate1_con ))
colnames(plate1_vol_con)<-c("Pool", "Average_con", "Total_Vol")

#Plate2
plate2<-read_xlsx(paste(filenames[2],".xlsx", sep=""), sheet=sheetnames[2],col_names = FALSE)
Plate2_vol<-as.numeric(plate2$X__14[seq(64,78,2)])
#need to calculate average concentration for the individuals wells to get pooled con
Plate2_con<-as.data.frame(lapply(plate2[seq(45,59,2), 1:12], as.numeric))
plate2_vol_con<-as.data.frame(cbind(seq((1+8),(8+8), 1),Plate2_vol, rowMeans(Plate2_con)))
colnames(plate2_vol_con)<-colnames(plate1_vol_con)

#Plate3
plate3<-read_xlsx(paste(filenames[3],".xlsx", sep=""), sheet=sheetnames[3],col_names = FALSE)
Plate3_vol<-as.numeric(plate3$X__14[seq(65,79,2)])
#need to calculate average concentration for the individuals wells to get pooled con
Plate3_con<-as.data.frame(lapply(plate3[seq(46,60,2), 1:12], as.numeric))
plate3_vol_con<-as.data.frame(cbind(seq((1+2*8),(8+2*8), 1),Plate3_vol, rowMeans(Plate3_con)))
colnames(plate3_vol_con)<-colnames(plate1_vol_con)

#Plate4
plate4<-read_xlsx(paste(filenames[4],".xlsx", sep=""), sheet=sheetnames[4],col_names = FALSE)
Plate4_vol<-as.numeric(plate4$X__14[seq(63,77,2)])
#need to calculate average concentration for the individuals wells to get pooled con
Plate4_con<-as.data.frame(lapply(plate4[seq(45,59,2), 1:12], as.numeric))
plate4_vol_con<-as.data.frame(cbind(seq((1+3*8),(8+3*8), 1), Plate4_vol, rowMeans(Plate4_con)))
colnames(plate4_vol_con)<-colnames(plate1_vol_con)

#Plates 5 and 6 are summarised at top of files:
plate5<-read_xlsx(paste(filenames[5],".xlsx", sep=""), sheet=sheetnames[5])
Plate5_vol<-plate5[1:8, 18]
plate5_vol_con<-cbind(seq((1+4*8),(8+4*8), 1),Plate5_vol, rep("NA", 8))
colnames(plate5_vol_con)<-colnames(plate1_vol_con)

plate6<-read_xlsx(paste(filenames[6],".xlsx", sep=""), sheet=sheetnames[6],col_names = FALSE)
Plate6_vol<-plate6[1:8, 20]
plate6_vol_con<-cbind(seq((1+5*8),(8+5*8), 1), Plate6_vol, rep("NA", 8))
colnames(plate6_vol_con)<-colnames(plate1_vol_con)

pool_contents<-rbind(plate1_vol_con, plate2_vol_con, plate3_vol_con,
                 plate4_vol_con, plate5_vol_con, plate6_vol_con)


#Combine these volumes and concentrations with the plants_in_pools data from above

plants_in_pools<-cbind(plants_in_pools, pool_contents)

#write_csv("to directory yet to be decided.csv)


#END SCRIPT (FOR NOW)