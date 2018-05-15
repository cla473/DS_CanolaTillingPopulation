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
		 # Define filename to be called
		 STEM=${IN_LIST["$SLURM_ARRAY_TASK_ID"]}
        	 # VIEW .sam file which converts it into a .bam file:[-b]=output is .bam; [S]=input is .sam (expects .bam as default)
        	 samtools view -bS ${STEM}.sam > ${STEM}.bam
		 # SORT the .bam files in case needed downstream  && remove unsorted.bam files to save space [O] = output is .bam	
		 samtools sort -O bam ${STEM}.bam ${STEM}_sorted.bam && rm ${STEM}.bam 
		 # INDEX the .bam files for Picard && remove the unindexed.bam files to save on space 
		 samtools index ${STEM}_sorted.bam ${STEM}_sorted__indexed.bam && rm ${STEM}_sorted.bam
		else
		 echo "Error: Missing array index as SLURM_ARRAY_TASK_ID" 
		fi
    	else
         echo "Error: Missing array index as SLURM_ARRAY_TASK_ID"
 fi

# For Submission:
# INDIR="/OSM/CBR/AF_DATASCHOOL/output/SB501086_0095_CHelliwell_CSIRO_Brapa_gDNA"  PUT YOUR DIRECTORY LOCATION 
# outputHERE
# NUM=$(expr $(ls -1 ${INDIR}/*.fastq.sam | wc -l) - 1)
# sbatch -a 0-$NUM --export INDIR="$INDIR" SAM_to_BAM.sh#

 