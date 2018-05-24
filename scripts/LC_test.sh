#!/bin/bash
#SBATCH --job-name=run_bwa_alignment
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --mem=10g

# For Submission:
# INDIR="/OSM/CBR/AF_DATASCHOOL/output/2018-05-03_canola/BWA"
# GENOME="/OSM/CBR/AF_DATASCHOOL/input/ref_genome/GCF_000686985.2_Bra_napus_v2.0_genomic.fasta"
# NUM=$(expr $(ls -1 ${INDIR}/*.fastq.gz | wc -l) - 1)
# sbatch -a 0-$NUM --export INDIR="$INDIR" --export GENOME="$GENOME"  LC_GATK.sh

OUTDIR= echo ` ${INDIR} | sed -r 's/BWA/gatk/g' `


if [ -d "$INDIR" ]
then
    SAMPLES=( `ls -1 ${INDIR}/*.fastq.gz` )
    if [ ! -z "$SLURM_ARRAY_TASK_ID" ]
    then
        i=$SLURM_ARRAY_TASK_ID
        echo `sample ${SAMPLES[$i]}.txt > ${OUTDIR}/LC_log.text
    else
        echo "Error: Missing array index as SLURM_ARRAY_TASK_ID"
    fi
else
    echo "Error: Missing input file directory as --export env INDIR or doesn't exist"
fi
