##############GET_TOPS_BASH###############################
#!/bin/bash
lab=hs_chip_10k_linear_quantile
pathIn=/scratch/shpakb/processed/${lab}
nGenes=200
# hs mm rt
organism=hs

qsub -N getTops << ENDINPUT
#PBS -l nodes=1:ppn=1,walltime=24:00:00,mem=4gb
#PBS -j oe 
#PBS -q dque
#PBS -M shpakb@gmail.com

module load R-3.5.3
Rscript /home/shpakb/gq/scripts/diffexp/getTops.R $pathIn $nGenes $organism
ENDINPUT
