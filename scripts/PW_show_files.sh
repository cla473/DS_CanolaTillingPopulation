#!/bin/bash

#SBATCH --job-name=show_file_dir
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATHC --mem=10g

## For testing only
#INDIR="/OSM/CBR/AF_DATASCHOOL/output/2018-05-03_canola/BWA"
#EXT="sam.bam"

#FILES=`ls -1 $INDIR/*.$EXT`
#echo $FILES
## Simply outputs file contents as a string and works :)

##Check for related input
## INDIR as $1 and EXT (file extension) as $2

if [ -z $1 ] ;
  then echo "* Error * - please provide INDIR"
  exit 1
else
  INDIR=$1
fi
## Can also include test if INDIR exists or not...
if [ -z $2 ] ;
  then echo "** Error ** please provide file extension (e.g. sam)"
  exit 1
else
  EXT=$2
fi
 
FILES=`ls -1 $INDIR/*.$EXT`

if [ ! $SLURM_ARRAY_TASK_ID ] ;
then
  i=$SLURM_ARRAY_TASK_ID
  echo "${FILES[$i]}"
fi

exit 0
