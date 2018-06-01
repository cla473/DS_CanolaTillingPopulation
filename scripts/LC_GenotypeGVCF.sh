#!/bin/bash

#SBATCH --job-name=Run_GenotypeGVCFs
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=5g

module load gatk/4.0.4.0
 
FILEDIR="/OSM/CBR/AF_DATASCHOOL/output/2018-05-03_canola/GVCF"
GENOME="/OSM/CBR/AF_DATASCHOOL/input/ref_genome/GCF_000686985.2_Bra_napus_v2.0_genomic.fasta"

# Clear our log file each time
#echo "Processing started... " > ${FILEDIR}/genotypeGVCF.log

gatk GenotypeGVCFs -R ${GENOME} --variant ${FILEDIR}/new_all_gvcf_raw.vcf -O ${FILEDIR}/output_v2.vcf 
 
#echo "Process completed" >> ${FILEDIR}/genotypeGVCF.log

# To run on Command Line:
#./LC_GenotypeGVCF.sh 

# To run on SLURM
#sbatch LC_GenotypeGVCF.sh 
