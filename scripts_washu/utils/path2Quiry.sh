#!/bin/bash

#c2.cp.v6.2.entrez.gmt // h.all.v6.2.entrez.gmt
pathIn=/home/shpakb/gq/data/geneSets/c2.cp.v6.2.entrez.gmt 
pathOut=/home/shpakb/gq/gq_queries/mm/cp/

# change to whatever you need hs/rt - q1/q2 ....
q1=hs
q2=mm

mkdir $pathOut

qsub -N gmt2Quiry << ENDINPUT
#PBS -l nodes=1:ppn=1,walltime=2:00:00,mem=2gb
#PBS -j oe
#PBS -q dque
#PBS -M shpakb@gmail.com

module load R-3.5.3
Rscript /home/shpakb/gq/scripts/utils/path2Quiry.R $pathIn $pathOut $q1 $q2
ENDINPUT