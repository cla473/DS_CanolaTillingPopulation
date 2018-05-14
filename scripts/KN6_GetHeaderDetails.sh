#!/bin/bash

#SBATCH --job-name=:LC_GetHeaderDetails
#SBATCH --time=00:10:00
#SBATCH --nodes=-1
#SBATCH --ntasks-per-node=5
#SBATCH --mem=2g

# Application specific commands
# added */* to be able to choose all files from 2018-05-03_canola folder
INDIR="/OSM/CBR/AF_DATASCHOOL/input/2018-05-03_canola/*/*.gz"


#add a header row to our header.txt file
echo "index, barcode, laneNo, poolNo, sampleNo, filename" > headers.txt


for FILE in $INDIR
do
    #echo "$FILE"

    #now get the header from the file
    HEADER=`zcat $FILE | head -n1`

    #now get the portion of the header that we want
    #"@NB501086:95:H72NFAFXX:1:11101:17128:1036 1:N:0:CGATGT"
    #splits header by : and cuts out columns based on index position
    BARCODE=`echo $HEADER | cut -d ':' -f 3 `
    LANENO=`echo $HEADER | cut -d ':' -f 4 `
    INDEX=`echo $HEADER | cut -d ':' -f 10`
   
    #splits the $FILE by '/' and gets the 8th column, then splits by '_' and gets the first and second columns
    # then deletes unwanted charachters (tr --delete ...)
    POOLNO=`echo $FILE | cut -d '/' -f 8 | cut -d '_' -f 1 | tr --delete Pool`
    SAMPLENO=`echo $FILE | cut -d '/' -f 8 | cut -d '_' -f 2 |tr --delete S `

    echo  $INDEX',' $BARCODE',' $LANENO',' $POOLNO',' $SAMPLENO',' $(basename "$FILE") >> headers.txt    
  

done
 
echo "Process completed"


