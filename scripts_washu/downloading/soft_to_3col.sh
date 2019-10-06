#!/bin/bash

# Converts GPLXXX_family.soft_.gz file into 3-column annotation table: 1) probe 2) symbol 3) entrez
#
# Writes GPL###.3col file to current directory as a result.

pathIn="/scratch/shpakb/GPL/soft/hs"
pathOut="/scratch/shpakb/GPL/3col/hs"

for GPL in *.gz do



P=$2
S=$3
E=$4

## all absent fields should be replaced with NONE string

zcat $pathIn | sed -n '/!platform_table_begin/,/!platform_table_end/ p' | sed '1d;$d' | tail -n +2 | awk -F "\t" -v a=$P -v b=$S -v c=$E '{print $a "\t" $b "\t" $c }' | sed 's/\t\t/\tNONE\t/g' | sed 's/\t$/\tNONE/g' > ${pathOut}/${GPL}.3col

done
