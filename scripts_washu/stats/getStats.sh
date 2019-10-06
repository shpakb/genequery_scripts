#!/bin/bash

label=hs_chip_10k_linear_quantile
dataPath=/scratch/shpakb/processed
modulesPath=/scratch/shpakb/processed/${label}/gqcmd/hs.modules.gmt

outFolder=${dataPath}/${label}

mkdir ${outFolder}/data

qsub -N getStats << ENDINPUT
#PBS -l nodes=1:ppn=1,walltime=24:00:00,mem=4gb
#PBS -j oe 
#PBS -o ${label}_st.txt
#PBS -q dque
#PBS -M shpakb@gmail.com

module load R-3.5.3

Rscript /home/shpakb/gq/scripts/stats/getEnrichedSets.R ${outFolder}/gq_out/hp ${outFolder}/data/hp_df.rds
Rscript /home/shpakb/gq/scripts/stats/getEnrichedSets.R ${outFolder}/gq_out/cp ${outFolder}/data/cp_df.rds
Rscript /home/shpakb/gq/scripts/stats/getDiffexpGQResults.R ${outFolder}/gq_out/diffexp ${outFolder}/data/diffexp.rds

Rscript /home/shpakb/gq/scripts/stats/getStats.R  ${outFolder}/data ${modulesPath}

ENDINPUT
