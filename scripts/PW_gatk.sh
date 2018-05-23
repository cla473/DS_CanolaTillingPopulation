#!/bin/bash

#SBATCH --job-name=show_file_dir
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --mem=10g
module load gatk
## For testing only
#INDIR="/OSM/CBR/AF_DATASCHOOL/output/2018-05-03_canola/BWA"
INDIR="/OSM/CBR/AF_DATASCHOOL/output/2018-05-03_canola/BWA"
OUTDIR="/OSM/CBR/AF_DATASCHOOL/output/2018-05-03_canola/gatk"
GENOME_REF="/OSM/CBR/AF_DATASCHOOL/input/genome/GCF_000686985.2_Bra_napus_v2.0_genomic.fna"


#FILES=`ls -1 $INDIR/*.$EXT`
#echo $FILES
## Simply outputs file contents as a string and works :)


#if [ -d $INDIR ] ;
#  then echo "* Error * - please provide INDIR"
#  exit 1
#fi

#if [ -d $OUTDIR ] ;
#  then echo "* Error * - please provide OUTDIR"
#  exit 1
#fi

#if [ -z $GENOME_REF ] ;
#  then echo "** Error ** please provide reference genome"
#  exit 1
#fi
 
FILES=`ls -1 $INDIR/*.sam.bam`

if [ -z ! "$SLURM_ARRAY_TASK_ID" ] ;
   then
       i=$SLURM_ARRAY_TASK_ID
       gatk HaplotypeCaller \
       -R $GENOME_REF \
       -I ${FILES[$i]}.sam.bam \
       -O ${OUTDIR}/${FILES[$i]}.gvcf \
       -ERF GVCF \
       -ploidy 72 \
       --max-alternate-alleles 6 >> ${OUTDIR}/${FILES[$i]}.log
fi

exit 0


# At prompt for submission
# INDIR="/OSM/CBR/AF_DATASCHOOL/output/2018-05-03_canola/BWA"
# GENOME_REF="/OSM/CBR/AF_DATASCHOOL/input/genome/GCF_000686985.2_Bra_napus_v2.0_genomic.fna"
# NUM=$(expr $(ls -1 ${INDIR}/*.sam.bam | wc -l) - 1)
# OUTDIR="/OSM/CBR/AF_DATASCHOOL/output/2018-05-03_canola/gatk"
# sbatch -a 0-$NUM --export INDIR="$INDIR" --export OUTDIR="$OUTDIR" --export GENOME_REF="$GENOME_REF" PW_gatk.sh