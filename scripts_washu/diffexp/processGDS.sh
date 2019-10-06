#!/bin/bash
organism=hs
pathIn=/scratch/shpakb/diffexp/gds/${organism}
pathOut=/scratch/shpakb/diffexp/gds_processed/${organism}

mkdir $pathOut
mkdir ${pathOut}/exp
mkdir ${pathOut}/cond
mkdir ${pathOut}/contrast

qsub -N processGDS << ENDINPUT
#PBS -l nodes=1:ppn=1,walltime=24:00:00,mem=4gb
#PBS -j oe 
#PBS -q dque
#PBS -M shpakb@gmail.com

module load R-3.5.3
Rscript /home/shpakb/gq/scripts/diffexp/processGDS.R $pathIn $pathOut $organism
ENDINPUT

###################################################
organism=mm
pathIn=/scratch/shpakb/diffexp/gds/${organism}
pathOut=/scratch/shpakb/diffexp/gds_processed/${organism}

mkdir $pathOut
mkdir ${pathOut}/exp
mkdir ${pathOut}/cond
mkdir ${pathOut}/contrast

qsub -N processGDS << ENDINPUT
#PBS -l nodes=1:ppn=1,walltime=24:00:00,mem=4gb
#PBS -j oe 
#PBS -q dque
#PBS -M shpakb@gmail.com

module load R-3.5.3
Rscript /home/shpakb/gq/scripts/diffexp/processGDS.R $pathIn $pathOut $organism
ENDINPUT

###################################################
organism=rn
pathIn=/scratch/shpakb/diffexp/gds/${organism}
pathOut=/scratch/shpakb/diffexp/gds_processed/${organism}

mkdir $pathOut
mkdir ${pathOut}/exp
mkdir ${pathOut}/cond
mkdir ${pathOut}/contrast

qsub -N processGDS << ENDINPUT
#PBS -l nodes=1:ppn=1,walltime=24:00:00,mem=4gb
#PBS -j oe 
#PBS -q dque
#PBS -M shpakb@gmail.com

module load R-3.5.3
Rscript /home/shpakb/gq/scripts/diffexp/processGDS.R $pathIn $pathOut $organism
ENDINPUT

