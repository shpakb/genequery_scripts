#!/bin/bash

#PBS -l nodes=1:ppn=1,walltime=24:00:00,mem=4gb
#PBS -j oe 
#PBS -q dque
#PBS -M shpakb@gmail.com

module load R-3.5.3
Rscript /home/shpakb/gq/scripts/diffexp/getConvTops.R
