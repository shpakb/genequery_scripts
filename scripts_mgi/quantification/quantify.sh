#!/bin/bash

SRR=$1
REFSEQ=$2
WDIR=$3

cd $WDIR

SRA=${SRR}.sra

mkdir $SRR

fastq-dump --split-3 $SRA
N=`ls $SRR*fastq | wc -l`

if [[ $N == 2 ]]
then
  echo "Two fastq files found; processing sample $SRR as a paired-ended experiment."
  echo "$REFSEQ -o $SRR $SRR*.fastq"
  kallisto quant -i $REFSEQ -o $SRR $SRR*.fastq
elif [[ $N == 3 ]]
then
  echo "Three fastq files found; removing single-end reads and processing sample $SRR as a paired-ended experiment."
  echo "$REFSEQ -o $SRR $SRR*.fastq" 
  kallisto quant -i $REFSEQ -o $SRR $SRR*.fastq
elif [[ $N == 1 ]]
then
  echo "One fastq file found; processing sample $SRR as a single-ended experiment."
  echo "$REFSEQ -o $SRR $SRR*.fastq"
  kallisto quant --single -l 200 -s 50 -i $REFSEQ -o $SRR $SRR*.fastq
else 
  echo "ERROR: Wrong number of input arguments!"
  exit 1
fi

echo "Quantification complite."
rm $SRR*fastq $SRR.sra
