#!/bin/bash

SRR=$1
SRA=${SRR}.sra

cd /scratch/shpakb/rnaseq_pipline

## MICE 
REF=/home/apredeus/reference/Assemblies/genprime_vM18/genprime_vM18_kallisto
## HUMAN
#REF=/home/apredeus/reference/Assemblies/genprime_v29_nopar/genprime_v29_nopar_kallisto

fastq-dump --split-3 $SRA
N=`ls $SRR*fastq | wc -l`

if [[ $N == 2 ]]
then
  echo "Two fastq files found; processing sample $SRR as a paired-ended experiment."
  kallisto quant -i $REF -o $SRR $SRR*.fastq
elif [[ $N == 3 ]]
then
  echo "Three fastq files found; removing single-end reads and processing sample $SRR as a paired-ended experiment."
  rm $SRR.fastq 
  kallisto quant -i $REF -o $SRR $SRR*.fastq
elif [[ $N == 1 ]]
then
  echo "One fastq file found; processing sample $SRR as a single-ended experiment."
  kallisto quant --single -l 200 -s 50 -i $REF -o $SRR $SRR*.fastq
else 
  echo "ERROR: Wrong number of input arguments!"
  exit 1
fi

rm $SRR*fastq $SRR.sra

