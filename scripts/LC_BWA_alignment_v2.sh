#!/bin/bash
#SBATCH --job-name=run_bwa_alignment
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --mem=10g

module load bwa

#TODO:
#  The INFILE and GENOME will need to be passed in
#  Needs to be ran on HPC (currently works locally) (and details put in here as comments)

<<<<<<< HEAD
#for testing purposes only
INFILE="/OSM/CBR/AF_DATASCHOOL/output/metadata/combined_data.csv"
GENOME="/OSM/CBR/AF_DATASCHOOL/input/genome/GCF_000686985.2_Bra_napus_v2.0_genomic.fna"
=======
#for testing only
#INFILE="/OSM/CBR/AF_DATASCHOOL/output/metadata/combined_data.csv"


if [ -z "$1" ];  ##Check if any input provided
  then 	
    echo "** Error ** No input -> please provide DIR & filename"
    exit 1
  else 
    INFILE=$1 ## Assumes valid input - no sanity check
fi
>>>>>>> 7aa19d25b8ed284473520f91ac8cf23654bc4b70



#NOTE:  The output directory is same as filenamePath directory except that 'input' is replace with 'output'

#need to check what we need here as far as validating the file goes
#if [ -f "$INFILE" ] && { echo "$INFILE file not found"; exit 99; }
<<<<<<< HEAD
if [ -f "$INFILE" ] 
then

    cat $INFILE | while read LINE
    do
        #echo $LINE

        #columns are:
        #   (1) Index, (2)Barcode, (3)Lane_No, (4)Pool, (5)Sample_No, (6)Filename, 
        #   (7) FileNamePath, (8) Sequence_Platform, (9) Sequence_Technique, 
        #   (10) Sequence_Date, (11) Processing_Centre

        #these are extracted here as they are referenced multiple times below
        INDEX=`echo $LINE | cut -d ',' -f1 | sed -e 's/^"//' -e 's/"$//' `
        BARCODE=`echo $LINE | cut -d ',' -f2 | sed -e 's/^"//' -e 's/"$//' `
        LANE=`echo $LINE | cut -d ',' -f3 `    
        POOL=`echo $LINE | cut -d ',' -f4 `    
        SAMPLE=`echo $LINE | cut -d ',' -f5 `    
        FILENAME=`echo $LINE | cut -d ',' -f6 | sed -e 's/^"//' -e 's/"$//' ` 
        FILEPATH=`echo $LINE | cut -d ',' -f7 | sed -e 's/^"//' -e 's/"$//' ` 
        PLATFORM=`echo $LINE | cut -d ',' -f8 | sed -e 's/^"//' -e 's/"$//' `  
        TECHNIQUE=`echo $LINE | cut -d ',' -f9 | sed -e 's/^"//' -e 's/"$//' `  
        SEQDATE=`echo $LINE | cut -d ',' -f10 | sed -e 's/^"//' -e 's/"$//' `   
        PROCCENTRE=`echo $LINE | cut -d ',' -f11 | sed -e 's/^"//' -e 's/"$//' `

        ID=`echo "${INDEX}.${LANE}.${INDEX}"`
        DS=`echo "Pool_${POOL}.Sample_${SAMPLE}"`
        PU=`echo "${BARCODE}.${LANE}"` 

        OUTDIR=`echo $(dirname ${FILEPATH}) | sed -e 's/input/output/' `
        echo ${OUTDIR}

        #now we are ready to build the full string to be passed as a parametre for  BWA
        RG1=`echo "@RG\tID:${ID}$\tBC:${INDEX}\tCN:${PROCCENTRE}\tDS:${DS}\tDT:${SEQDATE}\t"`
        RG2=`echo "${RG1}LB:${BARCODE}\tPG:${TECHNIQUE}\tPL:${PLATFORM}\tPM:{TECHNIQUE}\t"`
        RG=`echo "${RG2}PU:${PU}\tSM:${POOL}" `
        echo ${RG}   

        if [ ! -f ${OUTDIR}/${FILENAME}.sam ]
        then
           bwa mem ${GENOME} ${FILEPATH} \
                  -t $THREADS \
                  -k $SEED \
                  -w $WIDTH \
                  -r $INTERNAL \
                  -T $SCORE \
                  -M \
                  -r ${RG} > ${OUTDIR}/${FILENAME}.sam 2>> ${OUTDIR}/${FILENAME}.log
        fi
    done 
fi
=======

cat $INFILE | while read LINE; do
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
>>>>>>> 7aa19d25b8ed284473520f91ac8cf23654bc4b70

