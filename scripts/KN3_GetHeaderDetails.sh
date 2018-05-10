#!/bin/bash

#SBATCH --job-name=:LC_GetHeaderDetails
#SBATCH --time=00:10:00
#SBATCH --nodes=-1
#SBATCH --ntasks-per-node=5
#SBATCH --mem=2g

# Application specific commands
INDIR="/OSM/CBR/AF_DATASCHOOL/input/2018-05-03_canola/*/*.gz"


#add a header row to our header.txt file
echo "id, filename, name, name, name" > headers.txt

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

    #DETAILS=`$HEADER | cut -d ':' -f 3,4,10 --output-delimiter=', '`
    #echo $DETAILS >> headers.txt

    #this works, but can't work out why the above doesn't work    
    barcode=`echo $HEADER | cut -d ':' -f 3,4 --output-delimiter=':'`
    index=`echo $HEADER | cut -d ':' -f 10`
    
    echo $count", " $(basename "$file")',' $barcode',' $index >> headers.txt
  
   #what I want to do is output a line
    #1, Pool25_S1_R1_001.fastq.gz, H72NFAFXX, 1, CGATGT
    #echo $count", "  $(basename "$file")", " $DETAILS  >> headers.txt

done
 
echo "Process completed"


