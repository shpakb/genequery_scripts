#!/bin/bash
pathIn=/scratch/shpakb/matrices/rt/seq_raw
pathOut=/home/shpakb/gq/data/rt_quantified.rds

qsub -N getSamples << ENDINPUT
#PBS -l nodes=1:ppn=1,walltime=24:00:00,mem=4gb
#PBS -j oe 
#PBS -q dque
#PBS -M shpakb@gmail.com

module load R-3.5.3
Rscript /home/shpakb/gq/scripts/stats/getSamples.R $pathIn $pathOut 
ENDINPUT
