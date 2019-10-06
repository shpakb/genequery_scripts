#!/bin/bash

#####################################################################################1

gdsResult=/home/shpakb/gq/scripts/downloading/gds_result_08-13-19/hs_chip.txt
pathOut=/scratch/shpakb/annotations/hs_chip/

# extract URL prefixes from the file
URLS=`grep "FTP download" $gdsResult | grep GSE | perl -ne 'm/GEO( | \(.*\) )(ftp\:\/\/ftp.*\/)/; print "$2\n"' | awk -F "," '{print $1}'`

for i in $URLS
do
    echo "Downloading from address $i" 
    wget -nc -P $pathOut $i/matrix/*_series_matrix.txt.gz  
done


echo "All downloads are now complete!" 







