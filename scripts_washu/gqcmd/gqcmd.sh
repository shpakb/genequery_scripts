#!/bin/bash

organism=hs
label=hs_chip_10k_linear_quantile
gqcmd=10k_gqcmd.jar

gqcmdPath=/home/shpakb/gq/scripts/gqcmd/${gqcmd}
gqdbPath=/scratch/shpakb/processed/${label}/gqcmd
queryPath=/scratch/shpakb/processed/${label}
outPath=/scratch/shpakb/processed/${label}/gq_out
diffexpPath=/scratch/shpakb/processed/${label}/geneSets
logsPath=/home/shpakb/gq/logs

mkdir $outPath
mkdir $outPath/hp
mkdir $outPath/cp
mkdir $outPath/diffexp

qsub -N ${gqcmd} << ENDINPUT
#PBS -l nodes=1:ppn=4,walltime=24:00:00,mem=3gb
#PBS -o ${logsPath}/${label}.txt
#PBS -j oe
#PBS -q dque
#PBS -M shpakb@gmail.com

module load java
#java -Xmx800m -jar $gqcmdPath bulkquery -dp $gqdbPath -q ${queryPath}/hp -d ${outPath}/hp
#java -Xmx800m -jar $gqcmdPath bulkquery -dp $gqdbPath -q ${queryPath}/cp -d ${outPath}/cp
java -Xmx800m -jar $gqcmdPath bulkquery -dp $gqdbPath -q ${diffexpPath} -d ${outPath}/diffexp

ENDINPUT
