#!/bin/bash 

SRR_LIST=/scratch/shpakb/rnaseq_pipline/srr.list

KK=`cat $SRR_LIST`
WDIR=`pwd`

COUNT=1

for i in $KK
do
  echo "==> ["`date +%H:%M:%S`"] Sample # $COUNT, sample $i."
  MASK=`echo $i | perl -ne 'printf "%s\n",substr $_,0,6'`
  wget ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/$MASK/$i/$i.sra
  COUNT=$((COUNT+1))

  if [ -f "$i.sra" ]; then
      nJobs=`showq | grep shpakb | wc -l`
      if [ "$nJobs" -lt 50 ]; then
          echo "subbmiting a job"
          bash submit_kallisto.sh $i
          echo "job has been submitted"
      else
          echo "waiting 10m"
          sleep 10m
          bash submit_kallisto.sh $i
          echo "job has been submitted"
      fi
  else
      touch /scratch/shpakb/rnaseq_pipline/kallisto_out/$i
  fi
  
done
