#!/bin/bash

pathIn=/home/shpakb/gq/gq_out/hs_8k_log/cp/
pathOut=/home/shpakb/gq/data/8k_log_cp_seq_hs.rds

qsub -N getEnrichedSets << ENDINPUT
#PBS -l nodes=1:ppn=1,walltime=24:00:00,mem=4gb
#PBS -j oe 
#PBS -q dque
#PBS -M shpakb@gmail.com

module load R-3.5.3
Rscript /home/shpakb/gq/scripts/stats/getEnrichedSets.R $pathIn $pathOut 
ENDINPUT
