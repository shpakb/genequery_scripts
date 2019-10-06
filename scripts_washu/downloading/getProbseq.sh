#!/bin/bash
filename='/home/shpakb/gq/scripts/downloading/gpl/hs_gpl.list'
DIR='/scratch/shpakb/GPL/probseq/hs'

mkdir /scratch/shpakb/GPL/probseq
mkdir /scratch/shpakb/GPL/probseq/hs
n=1
while IFS=$' \t\n\r' read -r GPL; do

if [ ${#GPL} -eq 8 ]; then
    URL="ftp://ftp.ncbi.nlm.nih.gov/geo/platforms/GPL${GPL:3:2}nnn/$GPL/suppl/${GPL}_probeseq.txt.gz"
elif [ ${#GPL} -eq 7 ]; then
    URL="ftp://ftp.ncbi.nlm.nih.gov/geo/platforms/GPL${GPL:3:1}nnn/$GPL/suppl/${GPL}_probeseq.txt.gz"
else
    URL="ftp://ftp.ncbi.nlm.nih.gov/geo/platforms/GPLnnn/$GPL/suppl/${GPL}_probeseq.txt.gz"
fi

wget -O $DIR/${GPL}_probeseq.txt.gz $URL

done < $filename