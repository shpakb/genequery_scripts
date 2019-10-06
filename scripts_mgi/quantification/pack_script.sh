#!/bin/bash

WDIR=`pwd`
FOLDERS=${WDIR}/kalisto_out/*
OUTDIR=/gscmnt/gc2676/martyomov_lab/shpakb/rna_seq/all_rn

for f in $FOLDERS
do
  if [[ -d $f ]]; then
    folder=$(basename $f)
    mv ${f}/abundance.tsv ${OUTDIR}/abund/${folder}.abundance.tsv
    mv ${f}/run_info.json ${OUTDIR}/json/${folder}.run_info.json
    rm -r $f
    echo $folder
  fi
done