#!/bin/bash

#SBATCH --job-name=:GetHeaderDetails
#SBATCH --time=00:10:00
#SBATCH --nodes=-1
#SBATCH --ntasks-per-node=5
#SBATCH --mem=2g

#define the dicrectory we are going to work with
#added */* to be able to choose all files from 2018-05-03_canola folder
INDIR="/OSM/CBR/AF_DATASCHOOL/input/2018-05-03_canola/*/*.gz"

echo "Process started...."

#add a header row to our header.txt file
echo "index, poolNo, sampleNo, repNo, barcode, laneNo, filename" > headers.txt


for FILE in $INDIR
do

    #get the filename (remove path information)
    FILENAME=`echo $(basename "$FILE")`
    #echo "File: $FILENAME"

    #now get the header from the file
    HEADER=`zcat $FILE | head -n1`

    #now get the portion of the header that we want
    #eg. @NB501086:95:H72NFAFXX:1:11101:17128:1036 1:N:0:CGATGT
    INDEX=`echo $HEADER | cut -d ':' -f 10 `
    BARCODE=`echo $HEADER | cut -d ':' -f 3 `
    LANE=`echo $HEADER | cut -d ':' -f 4 `

    #to cut the pool number out of the filename
    #eg. Pool25_S1_R1_001.fastq.gz
    POOL=`echo $FILENAME | cut -d '_' -f 1 | tr --delete Pool `
    SAMPLE=`echo $FILENAME | cut -d '_' -f 2 | tr --delete S ` 
    REP=`echo $FILENAME | cut -d '_' -f 3 | tr --delete R ` 

    #now output the details to the text file
    echo $INDEX',' $POOL',' $SAMPLE',' $REP',' $BARCODE',' $LANE',' $FILENAME >> headers.txt    
  
done
 
echo "Process completed"


