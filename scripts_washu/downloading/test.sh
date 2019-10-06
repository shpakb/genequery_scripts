#!/bin/bash
filename='/home/shpakb/gq/scripts/downloading/gpl/hs_gpl.list'
DIR='/scratch/shpakb/GPL/3col/hs'
n=1
while read line; do

sed -e 's/.*(\d+)*/$1/g' $line

done < $filename