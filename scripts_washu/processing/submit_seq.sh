#!/bin/bash

# list should contain trailing /n , othervise last line skiped

# Ins and outs 
scriptDir=`pwd`
expmat_list=${scriptDir}/hs_seq.list
#expmat_list=${scriptDir}/test

label=hs_seq_10k_linear_quantile
#label=test

inDir=/scratch/shpakb/rnaseq_raw
outDir=/scratch/shpakb/processed

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
mkdir ${outDir}
mkdir ${outDir}/eigengenes
mkdir ${outDir}/modules
mkdir ${outDir}/heatmaps
mkdir ${outDir}/matrices
mkdir ${outDir}/logs

processed_list=`cut -f 2 $outDir/processing.tsv`

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
#PBS -l nodes=1:ppn=1,walltime=4:00:00,mem=5gb
#PBS -o ${outDir}/logs/${line}.txt
#PBS -q dque
#PBS -M shpakb@gmail.com
#PBS -j oe 

module load R-3.5.3
Rscript ${scriptDir}/process_seq.R $inFile $outDir $nGenes $ct $logScaleF $quantileF $expMatF $modulesF $eigengenesF $svgF 
ENDINPUT

fi

done < ${expmat_list}
