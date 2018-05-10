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
echo "filename, poolNumber, barcode, laneNumber, index" > headers.txt

let count=0

for file in $INDIR
do
    #increment our count, so we can output it
    ((count++))
    #echo "$file"
    ##echo $count", " $(basename "$file") >> headers.txt

    #now get the header from the file
    #HEADER=`head -1 $file | gunzip` - this gives unexpected end of file erros
    HEADER=`zcat $file | head -n1`
    #echo "  "$HEADER >> headers.txt

    #now get the portion of the header that we want
    #"@NB501086:95:H72NFAFXX:1:11101:17128:1036 1:N:0:CGATGT"

    DETAILS=`echo $HEADER | cut -d ':' -f 3,4,10 --output-delimiter=', '`
    #POOL=`echo $file | cut -d '_' -f 2 --output-delimiter=', '`
    
 
  
  #to cut the pool number out of the filename
   POOL=`echo $file | cut -d '/' -f 8 | cut -c 1-9 --output-delimiter=', '`

    

    #echo $DETAILS >> headers.txt

    
    #echo $count", " $(basename "$file")',' $DETAILS >> headers.txt
    echo  $(basename "$file")',' $POOL ',' $DETAILS >> headers.txt    
  
   #what I want to do is output a line
    #1, Pool25_S1_R1_001.fastq.gz, H72NFAFXX, 1, CGATGT
    #echo $count", "  $(basename "$file")", " $DETAILS  >> headers.txt

done
 
echo "Process completed"


