#!/bin/bash
#SBATCH --job-name=run_fastqc
#SBATCH --time=00:10:00
#SBATCH --ntasks-per-node=5
#SBATCH --mem=10g

module load picard

#initially using .bam, file generated from the sample.sam example. 
#Could not find an accompanying reference genome for this one, so the below needs to be
#trialled and corrected  with .bam files and a completementary genome


if [ -d "$INDIR" ]
	then
     	# generate a list of the .bam file names to call in ---- or do we need .bai files?
     	IN_LIST=( `ls -1 ${INDIR}/*.bam` )
		if [ ! -z "$SLURM_ARRAY_TASK_ID" ]			
       		 then
		 # Define filename to be called from the INDIR 
		 STEM=${IN_LIST["$SLURM_ARRAY_TASK_ID"]}
        	 # run an overall alignment assessment on the bam file
		 picard CollectAlignmentSummaryMetrics INPUT=${STEM}_sample_sorted.bam OUTPUT=${STEM}_align_assessment.txt 
		 # assess the complexity of the code
		 picard EstimateLibraryComplexity I=${STEM}_sample_sorted.bam O=${STEM}_est_lib_complexity.txt
		 # assess the GC content = this is not yet working ---NEED HELP--- 
		 picard CollectGcBiasMetrics CHART_OUTPUT=${STEM}_plots.pdf INPUT=${STEM}_sample_sorted.bam OUTPUT=${STEM}_output_GC.txt 
			SUMMARY_OUTPUT=${STEM}_summary_output.txt
		# Whole genome sequencing assessment --- NEEDS THE REFERENCE GENOME HERE		
		picard CollectWgsMetrics I=${STEM}_sample_sorted.bam O=${STEM}_whole_genome_allign.txt R=REFERENCE_GENOME
		else
		 echo "Error: Missing array index as SLURM_ARRAY_TASK_ID" 
		fi
    	else
         echo "Error: Missing array index as SLURM_ARRAY_TASK_ID"
 fi

# For Submission - from Jared's previous file -- UPDATE_ME:
# INDIR="/OSM/CBR/AF_DATASCHOOL/output/SB501086_0095_CHelliwell_CSIRO_Brapa_gDNA"  PUT YOUR DIRECTORY LOCATION 
# outputHERE
# NUM=$(expr $(ls -1 ${INDIR}/*.fastq.sam | wc -l) - 1)
# sbatch -a 0-$NUM --export INDIR="$INDIR" SAM_to_BAM.sh#

 
