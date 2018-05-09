#!/bin/bash

#SBATCH --job-name=:LC_GetHeaderDetails
#SBATCH --time=00:05:00
#SBATCH --ntasks=10
#SBATCH --mem=2g

# module load fastqc

# Application specific commands
# INDIR="../../OSM/CBR/AF_DATASCHOOL/input/2018-05-03_canola/NB501086_0095_CHelliwell_CSIRO_Brapa_gDNA/"
# NUM=$(expr $(ls -1 ${INDIR}/*.fastq.gz | wc -l) - 1)
# sbatch -a 0-$NUM INDIR="$INDIR" LC_GetHeaderDetails.sh

#INFILES=(`ls -1 ${INDIR}/*.gz | perl -pe 's/.+\/(.+)\.gz/$1/' `);
INFILES=(`ls -1 ${INDIR}/*.gz`);


echo "Getting header details from files  ...."

if [ ! -z "$SLURM_ARRAY_TASK_ID" ]
then

#    i=$SLURM_ARRAY_TASK_ID
#    fastqc ${INFILES[$i]} 
    echo ${INFILES[$i]}.gz >> headers.txt
#    head -n1 ${INFILES[$i]} | gunzip >> headers.txt

else
    echo "Error: Missing array index as SLURM_ARRAY_TASK_ID"
fi
echo "Process completed .."
