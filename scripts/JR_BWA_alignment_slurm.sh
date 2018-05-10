#!/bin/bash
#SBATCH --job-name=run_bwa_alignment
#SBATCH --time=00:10:00
#SBATCH --ntasks-per-node=5
#SBATCH --mem=20g
module load bwa
if [ -d "$INDIR" ]
then
     SAMPLES=( `ls -1 ${INDIR}/*.fastq.gz` )
    if [ ! -z "$SLURM_ARRAY_TASK_ID" ]
    then
        i=$SLURM_ARRAY_TASK_ID
        fastqc ${SAMPLES[$i]}
    else
        echo "Error: Missing array index as SLURM_ARRAY_TASK_ID"
    fi
else
    echo "Error: Missing input file directory as --export env INDIR or doesn't exist"
fi


# For Submission:
#
# INDIR="./blah/blah/"       PUT YOUR DIRECTORY LOCATION HERE
# NUM=$(expr $(ls -1 ${INDIR}/*.fastq.gz | wc -l) - 1)
#sbatch -a 0-$NUM INDIR="$INDIR" JR_bwa_aligment.sh

