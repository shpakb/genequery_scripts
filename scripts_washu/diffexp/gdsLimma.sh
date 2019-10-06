#!/bin/bash

organism=hs
lab=hs_chip_10k_linear_quantile
nGenes=10000

inDir=/scratch/shpakb/diffexp/gds_processed/${organism}
outDir=/scratch/shpakb/processed/${lab}

# Ins and outs 
scriptDir=`pwd`
gse_list=${scriptDir}/hs_gds.list
#gse_list=${scriptDir}/test

mkdir ${outDir}/diffexp/
mkdir ${outDir}/diffexp_logs/
while read -r line; do

qsub -N ${line} << ENDINPUT
#PBS -l nodes=1:ppn=1,walltime=24:00:00,mem=3gb
#PBS -o ${outDir}/diffexp_logs/${line}.txt
#PBS -j oe 
#PBS -q dque
#PBS -M shpakb@gmail.com

module load R-3.5.3
Rscript /home/shpakb/gq/scripts/diffexp/gdsLimma.R $line $inDir $outDir $nGenes 
ENDINPUT

done < ${gse_list}
