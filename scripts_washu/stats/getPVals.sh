#!/bin/bash
pathIn=/home/shpakb/gq/diffexp/10k
pathOut=/home/shpakb/gq/data/10k_t_pValue_df.rds
nGenes=200
# sorting diffexpresed genes by "t" or "logFold"
sort=t

qsub -N getPvals_${i} << ENDINPUT
#PBS -l nodes=1:ppn=1,walltime=24:00:00,mem=4gb
#PBS -j oe 
#PBS -q dque
#PBS -M shpakb@gmail.com

module load R-3.5.3
Rscript /home/shpakb/gq/scripts/stats/getPVals.R $nChunks ${i} $pathIn $pathOut $nGenes $sort 
ENDINPUT
