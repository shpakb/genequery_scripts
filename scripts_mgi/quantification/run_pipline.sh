#!/bin/bash 

WDIR=`pwd`
# list of srr to quantify
SRR_LIST=/gscmnt/gc2676/martyomov_lab/shpakb/rna_seq/quantification_pipline/srr.list
# reference geneome
# rat
#REFSEQ=/gscmnt/gc2676/martyomov_lab/shpakb/Assemblies/rnor_v6/rnor_v6_kallisto
# mice
REFSEQ=/gscmnt/gc2676/martyomov_lab/shpakb/Assemblies/genprime_vM18/genprime_vM18_kallisto

SRR_LIST=`cat $SRR_LIST`

COUNT=1

# initializing log file 
echo "srr\tstatus">> quantification.log

for SRR in $SRR_LIST
do  
  echo "==> ["`date +%H:%M:%S`"] Sample # $COUNT, sample $SRR."
  MASK=`echo $SRR | perl -ne 'printf "%s\n",substr $_,0,6'`
  wget ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/$MASK/$SRR/$SRR.sra
  COUNT=$((COUNT+1))

  if [ -f "$SRR.sra" ]; then
      nJobs=`bjobs | wc -l`
      if [ "$nJobs" -lt 50 ]; then
          echo "subbmiting a job"
          bsub -q research-hpc -M 4000000 -R 'select[mem>4000] rusage[mem=4000]' -o ${SRR}.log -e ${SRR}.err -a "docker(shpakb/gq-quant)" /bin/bash -c "bash ${WDIR}/quantify.sh $SRR $REFSEQ $WDIR"
          echo "job has been submitted"
      else
          echo "waiting 10m"
          sleep 10m
          bsub -q research-hpc -M 4000000 -R 'select[mem>4000] rusage[mem=4000]' -o ${SRR}.log -e ${SRR}.err -a "docker(shpakb/gq-quant)" /bin/bash -c "bash ${WDIR}/quantify.sh $SRR $REFSEQ $WDIR"
          echo "job has been submitted"
      fi
  else
      echo "${SRR}\tMissing sra file" >> quantification.log
  fi

done


