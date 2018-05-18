#!/bin/bash
#SBATCH --job-name=run_bwa_alignment
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --mem=10g

module load bwa

#TODO:
#  The INFILE and GENOME will need to be passed in - *DONE* PW
#  Needs to be ran on HPC (currently works locally) (and details put in here as comments)
#  Trial comments added below

OUTDIR="/OSM/CBR/AF_DATASCHOOL/output/2018-05-03_canola/BWA"

#PW - added input for parameters to pass to script# 
if [ -z "$GENOME" ] ; ## Check for provided input - first, assumed to be genome
  then
    echo "* Error * -> please provide genome location and name"
    exit 1
fi


if [ -z "$INFILE" ] ; ## Another check - this time for metadata
  then
    echo "* Error * -> provide location and name for metadata"
    exit 1
fi

#for testing purposes only
#INFILE="/OSM/CBR/AF_DATASCHOOL/output/metadata/combined_data.csv"
#GENOME="/OSM/CBR/AF_DATASCHOOL/input/genome/GCF_000686985.2_Bra_napus_v2.0_genomic.fna"


#NOTE:  The output directory is same as filenamePath directory except that 'input' is replace with 'output'

if [ -f "$INFILE" ] ;
  then

    cat $INFILE | while read LINE
    do
#       echo $LINE

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

        FILE_WITH_PATH=`echo $LINE | cut -d ',' -f7 | sed -e 's/^"//' -e 's/"$//' `
#	
#	Changed variable to indicate pathname
## PW-  Spoke with Kerensa in relation to this
#	-inclusion of this as part of output means that there are multiple paths for each data set/sample
#	given that this info is part of the metadata, there's an argument to have a single folder/directory for BWA output
# 	will adopt this approach - OUTDIR explicitly hard coded and defined at start of script

        PLATFORM=`echo $LINE | cut -d ',' -f8 | sed -e 's/^"//' -e 's/"$//' `  
        TECHNIQUE=`echo $LINE | cut -d ',' -f9 | sed -e 's/^"//' -e 's/"$//' `  
        SEQDATE=`echo $LINE | cut -d ',' -f10 | sed -e 's/^"//' -e 's/"$//' `   
        PROCCENTRE=`echo $LINE | cut -d ',' -f11 | sed -e 's/^"//' -e 's/"$//' `

        ID=`echo "${BARCODE}.${LANE}.${INDEX}"` ## Double reference to index
        DS=`echo "Pool_${POOL}.Sample_${SAMPLE}"`
        PU=`echo "${BARCODE}.${LANE}"` 
#       OUTDIR=`echo $(dirname ${FILEPATH}) | sed -e 's/input/output/' `  ## Changes 'input' to 'output' in filename - different paths present in data set


        #now we are ready to build the full string to be passed as a parametre for  BWA
        RG1=`echo "@RG\tID:${ID}\tBC:${INDEX}\tCN:${PROCCENTRE}\tDS:${DS}\tDT:${SEQDATE}\t"`
        RG2=`echo "${RG1}LB:${BARCODE}\tPG:${TECHNIQUE}\tPL:${PLATFORM}\tPM:${TECHNIQUE}\t"`
        RG=`echo "${RG2}PU:${PU}\tSM:${POOL}" `
#        echo ${RG}   


## After building @RG 'Read Group', parse as string to BWA for processing....

        if [ ! -f ${OUTDIR}/${FILENAME}.sam ]
         then
           bwa mem ${GENOME} ${FILE_WITH_PATH} \
	     -M \
             -R ${RG} > ${OUTDIR}/${FILENAME}.sam 2>> ${OUTDIR}/${FILENAME}.log
         fi
   done 
fi

exit 0


# For submission:

# INFILE="/OSM/CBR/AF_DATASCHOOL/output/metadata/combined_data.csv"
# GENOME="/OSM/CBR/AF_DATASCHOOL/input/genome/GCF_00068695.2_Bra_napus_v2.0_genomic.fna"
# NUM=`expr $(wc -l $INFILE | cut -d" " -f1) - 1`
# sbatch -a 0-$NUM --export GENOME="$GENOME" --export INFILE="$INFILE" LC_BWA_alignment_v2.sh


