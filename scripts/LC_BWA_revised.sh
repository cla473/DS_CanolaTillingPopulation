#!/bin/bash
#SBATCH --job-name=run_bwa_alignment
#SBATCH --time=01:00:00
#SBATCH --ntasks=10
#SBATCH --mem=10g

#Note:  The path to the combined_data.csv will be passed in
#       This fill is a list of files to process and includes (hopefully) all of the relevant information
#       required to run the process

#NOTE:  The output directory is same as filenamePath directory except that 'input' is replace with 'output'

#for testing only
INFILE="/OSM/CBR/AF_DATASCHOOL/output/metadata/combined_data.csv"

module load bwa

#this saves the original input format, then sets the IFS to comma separated format
#OLDIFS=$IFS
#IFS=,

#need to check what we need here as far as validating the file goes
#if [ -f "$INFILE" ] && { echo "$INFILE file not found"; exit 99; }

cat $INFILE | while read LINE
do
    #echo $LINE
    FN=`echo $LINE | cut -d ',' -f6`   #FileName"
    echo "FN : $FN "

    ID=`echo $LINE | cut -d ',' -f1`  #Index"
    echo "ID : $ID"

    BC=`echo $LINE | cut -d ',' -f2`  #Barcode"
    echo "BC : $BC"

    CN=`echo $LINE | cut -d ',' -f17`  #processing_centre"
    echo "CN : $CN"

    #echo "DS : Description - undefined - should this contain combined pool/sample/plant/plate info???"

    DT=`echo $LINE | cut -d ',' -f16`   #sequence_date"
    echo "DT : $DT"

    #echo "FO : Flow Order - undefined"
    #echo "KS : Array of necleotide bases - undefined"
    #echo "LB : Library - undefined"

    PG=`echo $LINE | cut -d ',' -f15`   #sequence_technique"
    echo "PG : $PG"

    #echo "PI : Predicted median insert - undefined"

    PL=`echo $LINE | cut -d ',' -f14`  #sequence_platform"
    echo "PL : $PL"

    #echo "PM : Platform model - undefined"
    #echo "PU : Platform unit - undefined"
    
    SM=`echo $LINE | cut -d ',' -f4`   #Pool"
    echo "SM : $SM"

done 

#reset the default format back to what it was
#IFS=$OLDIFS


