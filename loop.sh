#!/bin/bash -x

######################################################################################################################
#The objective of this bash script is to call the pipeline.sub script n times, one for each of the supplied samples. #
#It can be launched with bash since it is not computationally expensive.					     					 #
#It is launced as: bash loop.sh supplementary_files/samplelist.txt						     						 #
######################################################################################################################

#Needed folders are created to store outputs.
cd /scratch/124-dogs/
mkdir output error adremoved aln bam picard split duplicates_mrkd atlas indelreal vcf pca haplo
cd /home/orocabert/

#A counter is set.
counter=0

#For each line of the supplied file...
for LINE in $(cat < $1)
#the pipeline.sub script is called, the counter increses and the program stops 2 seconds.
do
#The option -o sets the output file name and location and the option -e sets the error file name and location,
#while the --export option introduces the variable $LINE to the variable $SAMPLE inside the .sub script.
	echo $LINE
	sbatch -o /scratch/124-dogs/output/$LINE.out -e /scratch/124-dogs/error/$LINE.err --export=SAMPLE=$LINE pipeline.sub
	counter=$((counter+1))	
	sleep 2
done

echo $counter "jobs have been sent."
