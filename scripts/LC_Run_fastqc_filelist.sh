#!/bin/bash

#SBATCH --job-name=:PoolAll
#SBATCH --time=00:05:00
#SBATCH --ntasks=5
#SBATCH --mem=2g

module load fastqc

# Application specific commands

INFILES=( "Pool10_S10_R1_001.fastq.gz" "Pool11_S11_R1_001.fastq.gz" "Pool12_S12_R1_001.fastq.gz" "Pool13_S13_R1_001.fastq.gz" \
 "Pool14_S14_R1_001.fastq.gz"  "Pool15_S15_R1_001.fastq.gz" );

echo "Processing fastqc files ...."

if [ ! -z "$SLURM_ARRAY_TASK_ID" ]
then
    echo $SLURM_ARRAY_TASK_ID
    echo ${INFILES[$i]}
    i=$SLURM_ARRAY_TASK_ID
    fastqc ${INFILES[$i]} 
else
    echo "Error: Missing array index as SLURM_ARRAY_TASK_ID"
fi
echo "Process completed .."
