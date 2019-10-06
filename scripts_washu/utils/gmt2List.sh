#!/bin/bash
label=6k_hs_log_seq
pathIn=/home/shpakb/gq/gqcmd_db/${label}/hs.modules.gmt
pathOut=/home/shpakb/gq/data/${label}_modules_list.rds

qsub -N gmt2List << ENDINPUT
#PBS -l nodes=1:ppn=1,walltime=24:00:00,mem=4gb
#PBS -j oe 
#PBS -q dque
#PBS -M shpakb@gmail.com

module load R-3.5.3
Rscript /home/shpakb/gq/scripts/db/gmt2List.R $pathIn $pathOut
ENDINPUT
