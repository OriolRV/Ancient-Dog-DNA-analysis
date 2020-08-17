#!/bin/bash -x

#############################################################################################
#The objective of this script is to calculate some stats of the samples in the passed file. #
#It can be used with bash since it is not computationally expensive.			    		#
#It is launched like this: bash create_stats_table.sh supplementary_files/samplelist.txt    #
#############################################################################################

echo "##Starting stats table creation."

#Some paths are set.
HOME=/home/orocabert
SCRATCH=/scratch/124-dogs

#The header of the file is echoed.
echo -e "Sample\tTotal_reads\tMapped_reads\t%_mapped_reads\tMQ0\t%_MQ_>0\tAverage_quality\t%_1st_split_reduction\t%_duplication\tSex" > $HOME/other_results/stats_table.txt

#For every sample in the supplied file...
for SAMPLE in $(cat < $1)
do
#Using bash and awk commands, the stats are extracted from the respective files and then are echoed into the output file.
	STATS=( $( head -n 45 $SCRATCH/bam/$SAMPLE"_sorted.stats" | grep -E "raw total sequences:|reads mapped:|reads MQ0:|average quality:" | cut -f3 ) )
	BIG=( $( du $SCRATCH/picard/$SAMPLE"_RG.bam" ) )
	SMALL=( $( du $SCRATCH/split/$SAMPLE"_placed.bam" ) )	
	DUPLICATES=( $( cat $SCRATCH/duplicates_mrkd/$SAMPLE"_metrics.txt" | grep -v "^#" | cut -f9 | tail -n 3 | head -n 1 ) )
	SEX=$( (tail -n2 /scratch/124-dogs/sex/$SAMPLE".Rx" | head -n 1 | cut -d" " -f9 | cut -d'"' -f1) )
	echo -e $SAMPLE"\t"\
${STATS[0]}"\t"\
${STATS[1]}"\t"\
$((100*${STATS[1]}/${STATS[0]}))"\t"\
${STATS[2]}"\t"\
$((100*(${STATS[1]}-${STATS[2]})/${STATS[0]}))"\t"\
${STATS[3]}"\t"\
$((100*$SMALL/$BIG))"\t"\
$(bc<<<100*$DUPLICATES)"\t"\
$SEX >> $HOME/other_results/stats_table.txt
done

echo "##Table finished."
