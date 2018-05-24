#!/bin/bash

#SBATCH --job-name=Combine_GVCF
#SBATCH --time=00:10:00
#SBATCH --nodes=-1
#SBATCH --ntasks=5
#SBATCH --mem=10g

module load gatk/4.0.4.0
# Combining GVCF files into one VCF callset
 
INDIR="/OSM/CBR/AF_DATASCHOOL/output/2018-05-03_canola/gatk"
OUTDIR="/OSM/CBR/AF_DATASCHOOL/output/2018-05-03_canola/GVCF"
GENOME_REF="/OSM/CBR/AF_DATASCHOOL/input/ref_genome/GCF_000686985.2_Bra_napus_v2.0_genomic.fasta"

#Why is Kerensa working with  .idx files, not .vcf?? 
echo ${INDIR}/*vcf | sed 's/.vcf */\n/g' > ${INDIR}/canola_gvcf.list

gatk GenotypeGVCFs \
   -R ${GENOME_REF} \
   --variant ${INDIR}/canola_gvcf.list \
   -O ${OUTDIR}/new_all_gvcf_raw.vcf \
   2> ${OUTDIR}/new_all_gvcf_raw.log
 
echo "Process completed"


#./MB_GenotypeGVCF.sh
