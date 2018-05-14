#!/bin/bash
#SBATCH --job-name=run_bwa_alignment
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --mem=10g
module load bwa
if [ -d "$INDIR" ]
then
     SAMPLES=( `ls -1 ${INDIR}/*.fastq.gz` )
    if [ ! -z "$SLURM_ARRAY_TASK_ID" ]
    then
        i=$SLURM_ARRAY_TASK_ID
        bwa mem GCF_000686985.2_Bra_napus_v2.0_genomic.fna ${SAMPLES[$i]} > ${SAMPLES[$i]}.txt
    else
        echo "Error: Missing array index as SLURM_ARRAY_TASK_ID"
    fi
else
    echo "Error: Missing input file directory as --export env INDIR or doesn't exist"
fi


# For Submission:
#
# INDIR="/OSM/CBR/AF_DATASCHOOL/input/jared/NB501086_0095_CHelliwell_CSIRO_Brapa_gDNA"       PUT YOUR DIRECTORY LOCATION HERE
# NUM=$(expr $(ls -1 ${INDIR}/*.fastq.gz | wc -l) - 1)
#sbatch -a 0-$NUM --export INDIR="$INDIR" JR_BWA_aligment_slurm.sh

