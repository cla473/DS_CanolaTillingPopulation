#!/bin/bash

#SBATCH --job-name=Combine_GVCF
#SBATCH --time=24:00:00
#SBATCH --ntasks=1
#SBATCH --mem=20g

module load gatk/4.0.4.0
# Combining GVCF files into one VCF callset
 
INDIR="/OSM/CBR/AF_DATASCHOOL/output/2018-05-03_canola/gatk"
OUTDIR="/OSM/CBR/AF_DATASCHOOL/output/2018-05-03_canola/GVCF"
GENOME_REF="/OSM/CBR/AF_DATASCHOOL/input/ref_genome/GCF_000686985.2_Bra_napus_v2.0_genomic.fasta"

#Why is Kerensa working with  .idx files, not .vcf?? 
# removing the list of filenames before generating a new one
[ -e ${INDIR}/canola_gvcf.list ] && rm ${INDIR}/canola_gvcf.list

# stepping through the .vcf files and collating a list in canola_gvcf.list (for "GenotypeGVCF")
for FILE in ${INDIR}/*.vcf
do
    echo $FILE
    FILENAME=`echo $(basename "$FILE")`
    echo $FILENAME
    #echo ${FILENAME} | sed 's/^/--variant /g' >> ${INDIR}/canola_gvcf.list
    echo ${FILE} >> ${INDIR}/canola_gvcf.list

done

#samples=$(find . | sed 's/.\///' | grep -E 'g.vcf$' | sed 's/^/--variant /')
#FILEDATA = `cat ${INDIR}/canola_gvcf.list` 

#gatk CombineGVCFs \
#   -R ${GENOME_REF} \
#   ${FILEDATA} \
#   -O ${OUTDIR}/new_all_gvcf_raw.vcf 2> ${OUTDIR}/new_all_gvcf_raw.log

gatk CombineGVCFs \
   -R ${GENOME_REF} \
   --variant ${INDIR}/canola_gvcf.list \
   -O ${OUTDIR}/new_all_gvcf_raw.vcf 
	#2> ${OUTDIR}/new_all_gvcf_raw.log

 
echo "Process completed"

# To run:
#./MB_GenotypeGVCF.sh == FROM COMMAND LIND

# To SLURM
#sbatch MG_GenotypeGVCF.sh 
