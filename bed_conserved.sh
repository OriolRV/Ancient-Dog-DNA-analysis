#!/bin/bash -x

#################################################################################################################################################
#This script allows to obtain a bed file with conserved positions from Ensembl to be used in ATLAS recal. 										#
#It also allows translating from NCBI "chr..." notation to NCBI "NC_..." notation (this was used for thr first 17 sample but now is commented). #
#It can be used with bash since it is not computationally expensive.					  														#
#It is launched as: bash bed_conserved.sh 																										#
#################################################################################################################################################

#First, some paths are set.
HOME=/home/orocabert;PROJECTS=/projects/124-dogs;SCRATCH=/scratch/124-dogs;REFGEN=$PROJECTS/CanFam3.1.fa

#Then, the bigbed file is downloaded from Ensembl (mf5sum hash: d62d606e390f4b0dbeb5cc08e088a463).
wget -O $SCRATCH/variants/gerp_dogs.bb ftp://ftp.ensembl.org/pub/release-100/bed/ensembl-compara/103_mammals.gerp_constrained_element/gerp_constrained_elements.canis_lupus_familiaris.bb

#Next, the program bigBedToBed (from UCSC), is downloaded. It will be used for the bigbed to bed conversion.
rsync -aP rsync://hgdownload.soe.ucsc.edu/genome/admin/exe/linux.x86_64/bigBedToBed $HOME/

#The next step is the conversion from the bigbed file into the bed file.
$HOME/bigBedToBed $SCRATCH/variants/gerp_dogs.bb $SCRATCH/variants/gerp_dogs.bed

#The non desired columns are eliminated, as well as the records for the non main 40 chromosomes (38 autosomes + X + M).
cut -f1-3 $SCRATCH/variants/gerp_dogs.bed | grep -vE "^J|^A" > $SCRATCH/variants/gerp_dogs1.bed

#The file is sorted.
sort -t$'\t' -k1,1n -k2,2n -k3,3n gerp_dogs1.bed > $SCRATCH/variants/gerp_dogs2.bed

#The chromosome nomenclature is adapted to that of NCBI.
awk '{if ($0 ~ /^MT/) {print "chrM\t"$2"\t"$3} else {print "chr"$0}}' $SCRATCH/variants/gerp_dogs2.bed > $SCRATCH/variants/gerp_dogs3.bed 

: <<'END'
#For the first 17 samples, the chromosome nomenclature was changed using the following code.
#For each line in the dictionary that contains the chromosome names relationship...
for LINE in $(cat < /home/orocabert/supplementary_files/chr_dictionary.txt)
do
#The original and the converted names are extracted.
	FROM=( $( echo $LINE | cut -d":" -f1 ) )
	TO=( $( echo $LINE | cut -d":" -f2 ) )
	echo "##Using file" $PREV "to pass from" $FROM "to" $TO"."
#The first and last conversion are done sepparately so correctly set the first input and last output.
	if [ $FROM == "chr1" ] || [ $FROM == "chrX" ]
	then
		if [ $FROM == "chr1" ]
		then
			sed "s/\<$FROM\>/$TO/g" $SCRATCH/variants/gerp_dogs3.bed > $SCRATCH/variants/$FROM"_tmp.bed"
		else
			sed "s/\<$FROM\>/$TO/g" $SCRATCH/variants/$PREV"_tmp.bed" > $SCRATCH/variants/$FROM"_tmp.bed"
		fi
#The rest of the conversions are done with this line.
	else
		sed "s/\<$FROM\>/$TO/g" $SCRATCH/variants/$PREV"_tmp.bed" > $SCRATCH/variants/$FROM"_tmp.bed"
	fi
#The name of the output file in this iteration is stored and will be used as input name in the next iteration.
	PREV=$FROM
done

#The conversion of the mitochondrial regions is done separately.
sed "s/\<chrM\>/NC_002008.4/g" $SCRATCH/variants/$PREV"_tmp.bed" > $SCRATCH/variants/gerp_dogs4.bed

END

#The X and M regions are extracted and moved to the end of the file.

cat $SCRATCH/variants/gerp_dogs4.bed | tail -n +30357 > $SCRATCH/variants/gerp_dogs5.bed
cat $SCRATCH/variants/gerp_dogs4.bed | head -n 30356 | tail -n 30330 >> $SCRATCH/variants/gerp_dogs5.bed
cat $SCRATCH/variants/gerp_dogs4.bed | head -n 26 >> $SCRATCH/variants/gerp_dogs5.bed

#Some overlaping regions of the mitochondrial chromosome are deleted.
sed -i '/NC_002008.4\t219\t280/d' $SCRATCH/variants/gerp_dogs5.bed
sed -i '/NC_002008.4\t291\t333/d' $SCRATCH/variants/gerp_dogs5.bed
sed -i '/NC_002008.4\t551\t701/d' $SCRATCH/variants/gerp_dogs5.bed
sed -i '/NC_002008.4\t1425\t1446/d' $SCRATCH/variants/gerp_dogs5.bed
sed -i '/NC_002008.4\t1603\t1635/d' $SCRATCH/variants/gerp_dogs5.bed
sed '/NC_002008.4\t1893\t2165/d' $SCRATCH/variants/gerp_dogs5.bed > $SCRATCH/variants/final_gerp.bed

#The temporary files created in the conversion are deleted.
rm $SCRATCH/variants/*tmp.bed $SCRATCH/variants/gerp_dogs*.bed
