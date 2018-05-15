#!/bin/bash
#SBATCH --job-name=run_fastqc
#SBATCH --time=00:10:00
#SBATCH --ntasks-per-node=5
#SBATCH --mem=10g

module load samtools/1.3.1

#module add samtools/1.3.1 ##--- From Kerensa's script, not sure why add not load?? is this version available?
#samtools --version logs/${TODAY}_main.log

if [ -d "$INDIR" ]
	then
     	# generate a list of the .sam file names to call in
     	SAMPLES=( `ls -1 ${INDIR}/*.sam` ) 
	# convert sam to sorted bam forma
		if [ ! -z "$SLURM_ARRAY_TASK_ID" ]			
       		 then
		 STEM=${IN_LIST["$SLURM_ARRAY_TASK_ID"]}
        # cd ${IN_DIR} --- From Kerensa's script, should be able too run in same directory
        # samtools fixmate -O bam ${STEM}*sam ${STEM}_fixmate.bam && rm ${STEM}*sam --- from Kerensa's script, 
	# sequencing with paired ends? Not needed here...?
        # samtools sort -O bam -@ 1 -m 8G -o ${STEM}_fixmate_sort.bam ${STEM}_fixmate.bam && rm ${STEM}_fixmate.bam
        	 samtools sort -O bam ${STEM}*sam ${STEM}_sorted.bam 
	# index does not read sam files so imporat as sam and first sort into a bam, write to *_sorted.bam
	# samtools index ${STEM}_fixmate_sort.bam
		 samtools index ${STEM}_sorted.bam > ${STEM}_sorted__indexed.bam && rm ${STEM}_sorted.bam
	# write the outputs as a bam (-O bam), index, write to *indexed.bam..
		else
		 echo "Error: Missing array index as SLURM_ARRAY_TASK_ID" 
		fi
    	else
         echo "Error: Missing array index as SLURM_ARRAY_TASK_ID"
 fi



# For Submission:
#
# INDIR="/OSM/CBR/AF_DATASCHOOL/output/SB501086_0095_CHelliwell_CSIRO_Brapa_gDNA"       PUT YOUR DIRECTORY 
LOCATION 
# outputHERE
# NUM=$(expr $(ls -1 ${INDIR}/*.fastq.sam | wc -l) - 1)
#sbatch -a 0-$NUM --export INDIR="$INDIR" SAM_to_BAM.sh#

 
