# GeneQuery scripts 

This repo contains scripts for downloading, preparing and updating GeneQuery database. There are also scripts for automatic statistics gathering and performance metrics measure. 

## Usage
Scripts are written to work with PBS. To run any of the scripts you have to bash corresponded  *.sh file. General form is 

```bash
bash <script_name.sh> nChunks pathIn pathOut [args]
```
Where <nChunks> is argument defining in what number of batches you want to process your files. Script will submit separate job to PBS to process each batch of files.

Also you have to manually specify resources you want PBS to allocate for each batch.  All you might need is to change number of cores(pnn) and amount of memory(mem) in this line 

```bash
#PBS -l nodes=1:ppn=1,walltime=24:00:00,mem=4gb
```

## Notebooks
Notebooks used to generate figures and some other things. 

## dee_archs_meta.7z 
Archive with DEE2 and ARCHS files used for figures. Dates on files ARCHS4:
- human_gsm_meta.rda - 6/2018 (v4)
- mouse_gsm_meta.rda - 6/2018 (v4)

DEE2:
- hsapiens_accessions.tsv.bz2 - 2019-08-01 01:28
- mmusculus_accessions.tsv.bz2 - 2019-07-26 13:51
- rnorvegicus_accessions.tsv.bz2 - 2019-06-02 22:18

