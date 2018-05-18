#!/bin/bash
#SBATCH --job-name=sam_to_bam
#SBATCH --time=00:10:00
#SBATCH --ntasks-per-node=5
#SBATCH --mem=10g

module load samtools/1.3.1

#module add samtools/1.3.1 ##--- From Kerensa's script, not sure why add not load?? is this version available?
#samtools --version logs/${TODAY}_main.log

if [ -d "$INDIR" ]
	then
     	# generate a list of the .sam file names to call in
     	IN_LIST=( `ls -1 ${INDIR}/*.sam` ) 
	# convert sam to sorted bam format
		if [ ! -z "$SLURM_ARRAY_TASK_ID" ]			
       		 then
		 # Define filename to be called from the INDIR 
		 STEM=${IN_LIST["$SLURM_ARRAY_TASK_ID"]}
        	 # VIEW .sam to  converts it into a .bam file:[-b]=output is .bam; 
		 # [S]=input is .sam (expects .bam as default) ##REMOVED .sam from ${STEM}.sam for trialling
        	 samtools view -bS ${STEM} > ${STEM}.bam
		 # SORT the .bam files in case needed downstream
		 # [O] = output is .bam [-o]: write output to following file	
		 samtools sort -O bam ${STEM}.bam -o ${STEM}_sorted.bam
		 # INDEX the .bam files for Picard && remove the unindexed.bam.bai (index file can't be opened
		 # but used down the  line  by Picard and GATK) 
		 samtools index ${STEM}_sorted.bam
		else
		 echo "Error: Missing array index as SLURM_ARRAY_TASK_ID" 
		fi
    	else
         echo "Error: Missing array index as SLURM_ARRAY_TASK_ID"
 fi

# For Submission - from Jared's previous file -- UPDATE_ME:

# INDIR='/OSM/CBR/AF_DATASCHOOL/output/2018-05-03_canola/BWA'
# NUM=$(expr $(ls -1 ${INDIR}/*.sam | wc -l) - 1)
# sbatch -a 0-$NUM --export INDIR="$INDIR" SAM_to_BAM.sh

 
