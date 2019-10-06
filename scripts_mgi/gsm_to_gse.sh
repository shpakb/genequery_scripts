#!/bin/bash

inDir=/gscmnt/gc2676/martyomov_lab/shpakb/rna_seq/all_hs

geneAnnot=/gscmnt/gc2676/martyomov_lab/shpakb/rna_seq/all_hs/genprime_v29.gene_name_entrez.tsv

# Human.SRR_to_GSM.tsv filtered
gsmToGse=/gscmnt/gc2676/martyomov_lab/shpakb/rna_seq/all_hs/Human.GSM_to_GSE.csv

bsub -q research-hpc -M 4000000 -R 'select[mem>4000] rusage[mem=4000]' -o gsm_to_gse.log -e gsm_to_gse.err -a "docker(rocker/tidyverse)" /bin/bash -c "Rscript /gscmnt/gc2676/martyomov_lab/shpakb/rna_seq/gsm_to_gse.R $inDir $gsmToGse $geneAnnot"
