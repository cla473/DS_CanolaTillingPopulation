#!/bin/bash
#SBATCH --job-name=run_bwa_alignment
#SBATCH --time=01:00:00
#SBATCH --ntasks=10
#SBATCH --mem=10g

module load bwa

DATAFILE="/OSM/CBR/AF_DATASCHOOL/output/metadata/combined_data.csv"
#NOTE:  OUTDIR is same as INDIR except that input is replace with output

if [ -d "$INDIR" ]
then
    IN_LIST=( `ls -1 ${INDIR}/*.fastq.gz` )
    if [ ! -z "$SLURM_ARRAY_TASK_ID" ]
    then
        FILE=${IN_LIST["$SLURM_ARRAY_TASK_ID"]}
        FILENAME=`echo $(basename "$FILE")`
        OUTPATH=`echo $(dirname "${FILE}") | sed -r 's/input/output/g `
        


#        STEM=${IN_LIST["$SLURM_ARRAY_TASK_ID"]}
#        SAMPLE=`grep "${STEM}*${READ_ONE}" $METADATA | cut -f2`   
#        SPECIES=`grep "${STEM}*${READ_ONE}" $METADATA | cut -f5`
#        INDEX=`grep "${STEM}*${READ_ONE}" $METADATA | cut -f3`
#        DATE=`grep "${STEM}*${READ_ONE}" $METADATA | cut -f4`
#	       (date library was contructed)
#        PLATFORM=`grep "${STEM}*${READ_ONE}" $METADATA | cut -f10`
#        LEFT=`grep "${STEM}*${READ_ONE}" $METADATA | cut -f11`
#        RIGHT=`grep "${STEM}*${READ_ONE}" $METADATA | cut -f12`
#        LIBRARY="${SAMPLE}.${LEFT}-${RIGHT}.${DATE}"
#                (sample id, index from header and sample date)
#        CENTRE=`grep "${STEM}*${READ_ONE}" $METADATA | cut -f8`
#        SEQDATE=`grep "${STEM}*${READ_ONE}" $METADATA | cut -f9`
#        UNIT=`gzip -cd ${IN_DIR}/${STEM}*p.fq.gz | head -1 | cut -d':' -f${UNIT_RX}`
#		(barcode, lane no from header)
#	ID=`echo ${UNIT}.${INDEX} | sed s/:/./g`
#            sed means replace ':' with '.'
#
#        echo "@RG\tID:${ID}\tCN:${CENTRE}\t"` \
#              `"DT:${SEQDATE}\tLB:${LIBRARY}\t"` \
#              `"PL:${PLATFORM}\tPU:${UNIT}\tSM:${SAMPLE}" > $OUT_DIR/${STEM}.log
#        if [ ! -f ${OUT_DIR}/${STEM}.sam ]
#        then
##           bwa mem GCF_000686985.2_Bra_napus_v2.0_genomic.fna ${SAMPLES[$i]} > ${SAMPLES[$i]}.txt
#
#            bwa mem ${BIG}/data/${REF%.*} ${IN_DIR}/${STEM}*p.fq.gz \
#                -t $THREADS \
#                -k $SEED \
#                -w $WIDTH \
#                -r $INTERNAL \
#                -T $SCORE \
#                -M \
#                -R 
#"@RG\tID:${ID}\tCN:${CENTRE}\tDT:${SEQDATE}\tLB:${LIBRARY}\tPL:${PLATFORM}\tPU:${UNIT}\tSM:${SAMPLE}" > 
#${OUT_DIR}/${STEM}.sam 2>> $OUT_DIR/${STEM}.log
#        fi

else
    echo "Error: Missing array index as SLURM_ARRAY_TASK_ID"
fi


# For Submission:
# INDIR="/OSM/CBR/AF_DATASCHOOL/input/2018-05-03_canola/SN877_0416_CHelliwell_CSIRO_Brapa_gDNA"
# INDIR="/OSM/CBR/AF_DATASCHOOL/input/2018-05-03_canola/NB501086_0095_CHelliwell_CSIRO_Brapa_gDNA"
# NUM=$(expr $(ls -1 ${INDIR}/*.fastq.gz | wc -l) - 1)
# sbatch -a 0-$NUM --export INDIR="$INDIR" LC_BWA_alignment_slurm.sh


