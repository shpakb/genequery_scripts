#!/bin/bash

# list should contain trailing /n , othervise last line skiped

# Ins and outs 
scriptDir=`pwd`
SM_list=${scriptDir}/hs_sm_filtered
#SM_list=${scriptDir}/test

label=hs_chip_10k_linear_quantile

inDir=/scratch/shpakb/series_matrices/hs_chip
outDir=/scratch/shpakb/processed
gplDir=/scratch/shpakb/3col/hs

# WGCNA params ########################################!!! AND THIS !!!
nGenes=10000
#pearson/bicor/spearman
ct=pearson
logScaleF=FALSE
quantileF=TRUE

# Specify needed output
expMatF=TRUE
modulesF=TRUE
eigengenesF=TRUE
svgF=FALSE

# Runing script

outDir=${outDir}/${label}
processed_list=`cut -f 2 $outDir/processing.tsv`

mkdir ${outDir}
mkdir ${outDir}/eigengenes
mkdir ${outDir}/modules
mkdir ${outDir}/heatmaps
mkdir ${outDir}/matrices
mkdir ${outDir}/logs

count=0

while read -r line; do
if [[ $processed_list == *$line* ]]
then
	echo "$line PROCESSED"
else
	count=$(( $count + 1 ))
	echo $count
	echo $line
	inFile=${inDir}/${line}

qsub -N ${line} << ENDINPUT
#PBS -l nodes=1:ppn=1,walltime=5:00:00,mem=6gb
#PBS -o ${outDir}/logs/${line}.txt
#PBS -q dque
#PBS -M shpakb@gmail.com
#PBS -j oe 

module load R-3.5.3
Rscript ${scriptDir}/process_chip.R $inFile $outDir $gplDir $nGenes $ct $logScaleF $quantileF $expMatF $modulesF $eigengenesF $svgF 
ENDINPUT

fi

done < ${SM_list}
