#!/bin/bash

inDir=/gscmnt/gc2676/martyomov_lab/shpakb/rna_seq/all_hs
geneMapping=/gscmnt/gc2676/martyomov_lab/shpakb/rna_seq/all_hs/genprime_v29.gene_tr.tsv
gsmList=/gscmnt/gc2676/martyomov_lab/shpakb/rna_seq/all_hs/hs_gsm.list
processedGsm=/gscmnt/gc2676/martyomov_lab/shpakb/rna_seq/all_hs/processing.tsv
# Human.SRR_to_GSM.tsv filtered
srrToGsm=/gscmnt/gc2676/martyomov_lab/shpakb/rna_seq/all_hs/Human.SRR_to_GSM.tsv

bsub -q research-hpc -M 4000000 -R 'select[mem>4000] rusage[mem=4000]' -o collapse.log -e collapse.err -a "docker(rocker/tidyverse)" /bin/bash -c "Rscript collapse_to_gsm.R $inDir $geneMapping $gsmList $processedGsm $srrToGsm"

# Mice run
#inDir=/gscmnt/gc2676/martyomov_lab/shpakb/rna_seq/all_mm
#geneMapping=/gscmnt/gc2676/martyomov_lab/shpakb/rna_seq/all_mm/genprime_vM18.gene_tr.tsv
#gsmList1=/gscmnt/gc2676/martyomov_lab/shpakb/rna_seq/all_mm/mm_gsm1.list
#gsmList2=/gscmnt/gc2676/martyomov_lab/shpakb/rna_seq/all_mm/mm_gsm2.list
#processedGsm=/gscmnt/gc2676/martyomov_lab/shpakb/rna_seq/all_mm/processing.tsv
#srrToGsm=/gscmnt/gc2676/martyomov_lab/shpakb/rna_seq/all_mm/Mouse.SRR_to_GSM.tsv

#bsub -q research-hpc -M 4000000 -R 'select[mem>4000] rusage[mem=4000]' -o collapse.log -e collapse.err -a "docker(rocker/tidyverse)" /bin/bash -c "Rscript collapse_to_gsm.R $inDir $geneMapping $gsmList1 $processedGsm $srrToGsm"
#bsub -q research-hpc -M 4000000 -R 'select[mem>4000] rusage[mem=4000]' -o collapse.log -e collapse.err -a "docker(rocker/tidyverse)" /bin/bash -c "Rscript collapse_to_gsm.R $inDir $geneMapping $gsmList2 $processedGsm $srrToGsm"
