#!/bin/bash

FILES=/scratch/shpakb/rnaseq_pipline/sra_files/*

for f in $FILES
do
    f="$(basename -- $f)"
    bash /scratch/shpakb/rnaseq_pipline/submit_kallisto.sh /scratch/shpakb/rnaseq_pipline/sra_files/${f}.sra
    echo ${f}.sra
done