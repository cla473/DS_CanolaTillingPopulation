#!/bin/bash

#SBATCH --job-name=:LC_GetHeaderDetails
#SBATCH --time=00:10:00
#SBATCH --nodes=-1
#SBATCH --ntasks-per-node=5
#SBATCH --mem=2g

# Application specific commands
# INDIR="/OSM/CBR/AF_DATASCHOOL/input/2018-05-03_canola/NB501086_0095_CHelliwell_CSIRO_Brapa_gDNA"
# NUM=$(expr $(ls -1 ${INDIR}/*.fastq.gz | wc -l) - 1)
# sbatch -a 0-$NUM INDIR="$INDIR" LC_GetHeaderDetails.sh

# INFILES=(`ls -1 ${INDIR}/*.gz | perl -pe 's/.+\/(.+)\.gz/$1/' `);

INFILES=(`ls -1 ${INDIR}/*.gz`);

echo "Getting header details from files  ...."

if [ ! -z "$SLURM_ARRAY_TASK_ID" ]
then

    head -n1 ${INFILES[$i]} | gunzip >> headers.txt

else
    echo "Error: Missing array index as SLURM_ARRAY_TASK_ID"
fi

