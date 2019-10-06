#!/bin/bash

pathIn=/home/shpakb/gq/gq_out/hs_8k_log/diffexp_8k_t/
pathOut=/home/shpakb/gq/data/8k_log/
label=hs_6k_t

qsub -N $label << ENDINPUT
#PBS -l nodes=1:ppn=1,walltime=24:00:00,mem=4gb
#PBS -j oe 
#PBS -q dque
#PBS -M shpakb@gmail.com

module load R-3.5.3
Rscript /home/shpakb/gq/scripts/stats/getDiffexpGQResults.R $pathIn $pathOut $label
ENDINPUT
