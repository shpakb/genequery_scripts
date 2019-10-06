##############################################################################################
label="hs_seq"
pathIn="/scratch/shpakb/annotations/"
pathIn=${pathIn}${label}/
pathOut="/home/shpakb/gq/data/metadata/"
pathOut=${pathOut}${label}/
mkdir ${pathOut}

qsub -N getMeta_${label} << ENDINPUT
#PBS -l nodes=1:ppn=1,walltime=6:00:00,mem=4gb
#PBS -q dque
#PBS -M shpakb@gmail.com
#PBS -j oe 

python /home/shpakb/gq/scripts/downloading/getMeta.py $pathIn $pathOut
ENDINPUT

##############################################################################################
label="hs_chip"
pathIn="/scratch/shpakb/annotations/"
pathIn=${pathIn}${label}/
pathOut="/home/shpakb/gq/data/metadata/"
pathOut=${pathOut}${label}/
mkdir ${pathOut}

qsub -N getMeta_${label} << ENDINPUT
#PBS -l nodes=1:ppn=1,walltime=6:00:00,mem=4gb
#PBS -q dque
#PBS -M shpakb@gmail.com
#PBS -j oe 

python /home/shpakb/gq/scripts/downloading/getMeta.py $pathIn $pathOut
ENDINPUT

##############################################################################################
label="mm_seq"
pathIn="/scratch/shpakb/annotations/"
pathIn=${pathIn}${label}/
pathOut="/home/shpakb/gq/data/metadata/"
pathOut=${pathOut}${label}/
mkdir ${pathOut}

qsub -N getMeta_${label} << ENDINPUT
#PBS -l nodes=1:ppn=1,walltime=6:00:00,mem=4gb
#PBS -q dque
#PBS -M shpakb@gmail.com
#PBS -j oe 

python /home/shpakb/gq/scripts/downloading/getMeta.py $pathIn $pathOut
ENDINPUT

##############################################################################################
label="mm_chip"
pathIn="/scratch/shpakb/annotations/"
pathIn=${pathIn}${label}/
pathOut="/home/shpakb/gq/data/metadata/"
pathOut=${pathOut}${label}/
mkdir ${pathOut}

qsub -N getMeta_${label} << ENDINPUT
#PBS -l nodes=1:ppn=1,walltime=6:00:00,mem=4gb
#PBS -q dque
#PBS -M shpakb@gmail.com
#PBS -j oe 

python /home/shpakb/gq/scripts/downloading/getMeta.py $pathIn $pathOut
ENDINPUT

##############################################################################################
label="rt_seq"
pathIn="/scratch/shpakb/annotations/"
pathIn=${pathIn}${label}/
pathOut="/home/shpakb/gq/data/metadata/"
pathOut=${pathOut}${label}/
mkdir ${pathOut}

qsub -N getMeta_${label} << ENDINPUT
#PBS -l nodes=1:ppn=1,walltime=6:00:00,mem=4gb
#PBS -q dque
#PBS -M shpakb@gmail.com
#PBS -j oe 

python /home/shpakb/gq/scripts/downloading/getMeta.py $pathIn $pathOut
ENDINPUT

##############################################################################################
label="rt_chip"
pathIn="/scratch/shpakb/annotations/"
pathIn=${pathIn}${label}/
pathOut="/home/shpakb/gq/data/metadata/"
pathOut=${pathOut}${label}/
mkdir ${pathOut}

qsub -N getMeta_${label} << ENDINPUT
#PBS -l nodes=1:ppn=1,walltime=6:00:00,mem=4gb
#PBS -q dque
#PBS -M shpakb@gmail.com
#PBS -j oe 

python /home/shpakb/gq/scripts/downloading/getMeta.py $pathIn $pathOut
ENDINPUT




