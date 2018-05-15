#!/bin/bash
#SBATCH --job-name=run_bwa_alignment
#SBATCH --time=01:00:00
#SBATCH --ntasks=10
#SBATCH --mem=10g

module load bwa

mkdir -p $OUT_DIR

IN_LIST=( $(tail -n +2 ${METADATA} | cut -f 1 | sed "s/_R[12].*//" | sort -u) );
if [ ! -z "$SLURM_ARRAY_TASK_ID" ]
    then
            STEM=${IN_LIST["$SLURM_ARRAY_TASK_ID"]}
            SAMPLE=`grep "${STEM}*${READ_ONE}" $METADATA | cut -f2`
            SPECIES=`grep "${STEM}*${READ_ONE}" $METADATA | cut -f5`
            INDEX=`grep "${STEM}*${READ_ONE}" $METADATA | cut -f3`
            DATE=`grep "${STEM}*${READ_ONE}" $METADATA | cut -f4`
            PLATFORM=`grep "${STEM}*${READ_ONE}" $METADATA | cut -f10`
            LEFT=`grep "${STEM}*${READ_ONE}" $METADATA | cut -f11`
            RIGHT=`grep "${STEM}*${READ_ONE}" $METADATA | cut -f12`
            LIBRARY="${SAMPLE}.${LEFT}-${RIGHT}.${DATE}"
            CENTRE=`grep "${STEM}*${READ_ONE}" $METADATA | cut -f8`
            SEQDATE=`grep "${STEM}*${READ_ONE}" $METADATA | cut -f9`
            UNIT=`gzip -cd ${IN_DIR}/${STEM}*p.fq.gz | head -1 | cut -d':' -f${UNIT_RX}`
            ID=`echo ${UNIT}.${INDEX} | sed s/:/./g`
            echo "@RG\tID:${ID}\tCN:${CENTRE}\t"` \
                   `"DT:${SEQDATE}\tLB:${LIBRARY}\t"` \
                   `"PL:${PLATFORM}\tPU:${UNIT}\tSM:${SAMPLE}" > $OUT_DIR/${STEM}.log
            if [ ! -f ${OUT_DIR}/${STEM}.sam ]
            then
#               bwa mem GCF_000686985.2_Bra_napus_v2.0_genomic.fna ${SAMPLES[$i]} > ${SAMPLES[$i]}.txt

                bwa mem ${BIG}/data/${REF%.*} ${IN_DIR}/${STEM}*p.fq.gz \
                    -t $THREADS \
                    -k $SEED \
                    -w $WIDTH \
                    -r $INTERNAL \
                    -T $SCORE \
                    -M \
                    -R 
"@RG\tID:${ID}\tCN:${CENTRE}\tDT:${SEQDATE}\tLB:${LIBRARY}\tPL:${PLATFORM}\tPU:${UNIT}\tSM:${SAMPLE}" > 
${OUT_DIR}/${STEM}.sam 2>> $OUT_DIR/${STEM}.log
            fi
    else
        echo "Error: Missing array index as SLURM_ARRAY_TASK_ID"
fi


