#!/bin/bash
#####################################################################################1
gdsResult=/home/shpakb/gq/scripts/downloading/gds_results_GDS_08-29-19/gds_result_hs.txt
pathOut=/scratch/shpakb/annotations/hs_gds/
mkdir pathOut

# extract URL prefixes from the file
URLS=`grep "FTP download" $gdsResult | grep GDS | perl -ne 'm/GEO( | \(.*\) )(ftp\:\/\/ftp.*\/)/; print "$2\n"' | awk -F "," '{print $1}'`

for i in $URLS
do
    echo "Downloading from address $i" 
    wget -nc -P $pathOut $i/soft/*[^l].soft.gz  
done


echo "All downloads are now complete!" 

#####################################################################################1
gdsResult=/home/shpakb/gq/scripts/downloading/gds_results_GDS_08-29-19/gds_result_mm.txt
pathOut=/scratch/shpakb/annotations/mm_gds/
mkdir pathOut

# extract URL prefixes from the file
URLS=`grep "FTP download" $gdsResult | grep GDS | perl -ne 'm/GEO( | \(.*\) )(ftp\:\/\/ftp.*\/)/; print "$2\n"' | awk -F "," '{print $1}'`

for i in $URLS
do
    echo "Downloading from address $i" 
    wget -nc -P $pathOut $i/soft/*[^l].soft.gz  
done


echo "All downloads are now complete!"

#####################################################################################1
gdsResult=/home/shpakb/gq/scripts/downloading/gds_results_GDS_08-29-19/gds_result_rn.txt
pathOut=/scratch/shpakb/annotations/rn_gds/
mkdir $pathOut

# extract URL prefixes from the file
URLS=`grep "FTP download" $gdsResult | grep GDS | perl -ne 'm/GEO( | \(.*\) )(ftp\:\/\/ftp.*\/)/; print "$2\n"' | awk -F "," '{print $1}'`

for i in $URLS
do
    echo "Downloading from address $i" 
    wget -nc -P $pathOut $i/soft/*[^l].soft.gz  
done


echo "All downloads are now complete!" 

