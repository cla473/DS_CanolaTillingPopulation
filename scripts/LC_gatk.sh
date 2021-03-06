#!/bin/bash

#SBATCH --job-name=show_file_dir
#SBATCH --time=01:00:00
#SBATCH --mem=10g
#SBATCH --ntasks=1

module load gatk/4.0.4.0

## For testing only
#INDIR="/OSM/CBR/AF_DATASCHOOL/output/2018-05-03_canola/BWA"
INDIR="/OSM/CBR/AF_DATASCHOOL/output/2018-05-03_canola/BWA"
OUTDIR="/OSM/CBR/AF_DATASCHOOL/output/2018-05-03_canola/gatk"
GENOME_REF="/OSM/CBR/AF_DATASCHOOL/input/ref_genome/GCF_000686985.2_Bra_napus_v2.0_genomic.fasta"
#FILENAME="Pool10_S10_R1_001.fastq.gz.sam_sorted.bam"


## Extra step needed to create dict for fa - use following
#picard CreateSequenceDictionary R= GCF_000686985.2_Bra_napus_v2.0_genomic.fasta O= GCF_000686985.2_Bra_napus_v2.0_genomic.dict
  
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
 
FILES=( `ls -1 ${INDIR}/*.sam_sorted.bam` );

if [ ! -z "$SLURM_ARRAY_TASK_ID" ] ;
then
       i=$SLURM_ARRAY_TASK_ID
#       echo "$i"
#       echo "${FILES[$i]}"
       FILENAME=`echo $(basename "${FILES[$i]}")`
       echo ${FILENAME}

       gatk HaplotypeCaller \
       -R ${GENOME_REF} \
       -I ${INDIR}/${FILENAME} \
       -O ${OUTDIR}/${FILENAME}.vcf \
       -ERC GVCF \
       -ploidy 72 \
       --max-alternate-alleles 6
fi


exit 0


# At prompt for submission
# INDIR="/OSM/CBR/AF_DATASCHOOL/output/2018-05-03_canola/BWA"
# GENOME_REF="/OSM/CBR/AF_DATASCHOOL/input/genome/GCF_000686985.2_Bra_napus_v2.0_genomic.fna"
# NUM=$(expr $(ls -1 ${INDIR}/*.sam.bam | wc -l) - 1)
# OUTDIR="/OSM/CBR/AF_DATASCHOOL/output/2018-05-03_canola/gatk"
# sbatch -a 0-47  LC_gatk.sh
