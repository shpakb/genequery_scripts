#!/bin/bash

label=hs_chip_10k_linear_quantile
pathIn=/scratch/shpakb/processed/${label}/modules
pathOut=/scratch/shpakb/processed/${label}/gqcmd
mkdir ${pathOut}
pathOut=${pathOut}/hs.modules.gmt

qsub -N making_gqdb << ENDINPUT
#PBS -l nodes=1:ppn=1,walltime=3:00:00,mem=2gb
#PBS -q dque
#PBS -M shpakb@gmail.com
#PBS -j oe 

python /home/shpakb/gq/scripts/db/gqdb.py $pathIn $pathOut
ENDINPUT
