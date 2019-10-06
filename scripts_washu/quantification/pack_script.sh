#!/bin/bash

FOLDERS=/scratch/shpakb/rnaseq_pipline/kallisto_out/*

mkdir /scratch/shpakb/rnaseq_pipline/abund/
mkdir /scratch/shpakb/rnaseq_pipline/json/
mkdir /scratch/shpakb/rnaseq_pipline/h5/

for f in $FOLDERS
do
  if [[ -d $f ]]; then
    folder=$(basename $f)
    mv ${f}/abundance.tsv /scratch/shpakb/rnaseq_pipline/abund/${folder}.abundance.tsv
    mv ${f}/run_info.json /scratch/shpakb/rnaseq_pipline/json/${folder}.run_info.json
    mv ${f}/abundance.h5 /scratch/shpakb/rnaseq_pipline/h5/${folder}.abundance.h5
    rm -r $f
    echo $folder
  fi
done