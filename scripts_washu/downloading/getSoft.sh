#!/bin/bash
filename='/home/shpakb/gq/scripts/downloading/gpl/hs_gpl.list'
DIR='/scratch/shpakb/GPL/3col/hs'
n=1
while IFS=$' \t\n\r' read -r GPL; do

if [ ${#GPL} -eq 8 ]; then
    URL="ftp://ftp.ncbi.nlm.nih.gov/geo/platforms/GPL${GPL:3:2}nnn/$GPL/soft/${GPL}_family.soft.gz"
elif [ ${#GPL} -eq 7 ]; then
    URL="ftp://ftp.ncbi.nlm.nih.gov/geo/platforms/GPL${GPL:3:1}nnn/$GPL/soft/${GPL}_family.soft.gz"
else
    URL="ftp://ftp.ncbi.nlm.nih.gov/geo/platforms/GPLnnn/$GPL/soft/${GPL}_family.soft.gz"
fi

wget -O $DIR/${GPL}_family.soft.gz $URL

done < $filename