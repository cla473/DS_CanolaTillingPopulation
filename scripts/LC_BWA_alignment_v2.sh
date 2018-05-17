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


#PW - added input for parameters to pass to script
if [ -z "$1" ] ; ## Check for provided input - first, assumed to be genome
  then
    echo "* Error * -> please provide genome location and name"
    exit 1
  else
GENOME=$1
fi

if [ -z "$2" ] ; ## Another check - this time for metadata
  then
    echo "* Error * -> provide location and name for metadata"
    exit 1
  else
INFILE=$2
fi

#for testing purposes only
#INFILE="/OSM/CBR/AF_DATASCHOOL/output/metadata/combined_data.csv"
#GENOME="/OSM/CBR/AF_DATASCHOOL/input/genome/GCF_000686985.2_Bra_napus_v2.0_genomic.fna"

#NOTE:  The output directory is same as filenamePath directory except that 'input' is replace with 'output'

#need to check what we need here as far as validating the file goes
#if [ -f "$INFILE" ] && { echo "$INFILE file not found"; exit 99; }
if [ -f "$INFILE" ] ;
  then

    cat $INFILE | while read LINE
    do
#        echo $LINE

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

        ID=`echo "${BARCODE}.${LANE}.${INDEX}"` ## Double reference to index
        DS=`echo "Pool_${POOL}.Sample_${SAMPLE}"`
        PU=`echo "${BARCODE}.${LANE}"` 
        OUTDIR=`echo $(dirname ${FILEPATH}) | sed -e 's/input/output/' `  ## Changes 'input' to 'output' in filename - different paths present in data set
#        echo ${OUTDIR}

        #now we are ready to build the full string to be passed as a parametre for  BWA
        RG1=`echo "@RG\tID:${ID}$\tBC:${INDEX}\tCN:${PROCCENTRE}\tDS:${DS}\tDT:${SEQDATE}\t"`
        RG2=`echo "${RG1}LB:${BARCODE}\tPG:${TECHNIQUE}\tPL:${PLATFORM}\tPM:${TECHNIQUE}\t"`
        RG=`echo "${RG2}PU:${PU}\tSM:${POOL}" `
        echo ${RG}   

## After building @RG 'Read Group', parse as string to BWA for processing....


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

exit 0


# For submission:

# INFILE="/OSM/CBR/AF_DATASCHOOL/output/combined_data.csv"
# GENOME="/OSM/CBR/AF_DATASCHOOL/input/genome/GCF_00068695.2_Bra_napus_v2.0_genomic.fna"
# NUM=`expr $(wc -l $INFILE | cut -d" " -f1) - 1`
# sbatch -a -0-$NUM --export GENOME=$GENOME" --export INFILE="$INFILE" LC_BWA_alignment_v2.sh


