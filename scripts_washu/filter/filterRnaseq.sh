library(tidyverse)
library(plyr)

dataDir="/home/shpakb/gq/data"

################################QUANTIFIED_GSM_DF#####################################
quantified_gsm <- readRDS(paste(dataDir, "metadata/hs_seq/gse.tsv", sep="\t")
quantified_gsm$gsm <- quantified_gsm$gsm %>% str_extract("GSM\\d+")
quantified_gsm$nGenes <- quantified_gsm$nGenes %>% as.character()  %>% as.integer
quantified_gsm$nNonZeroGenes <- quantified_gsm$nNonZeroGenes %>% as.character %>% as.integer
quantified_gsm <- quantified_gsm %>% select(-gse)
quantified_gsm <- quantified_gsm %>% distinct()
# apperantly some gsm quantified twice in context of two different GSE
quantified_gsm <- quantified_gsm %>% aggregate(nNonZeroGenes ~ gsm, data=., FUN=max)
quantified_gsm$lab <- "Homo sapiens"
temp_df <- quantified_gsm
quantified_gsm <- readRDS("C:\\Projects\\gq\\metadata\\mm_quantified.rds")
quantified_gsm$gsm <- quantified_gsm$gsm %>% str_extract("GSM\\d+")
quantified_gsm$nGenes <- quantified_gsm$nGenes %>% as.character()  %>% as.integer
quantified_gsm$nNonZeroGenes <- quantified_gsm$nNonZeroGenes %>% as.character %>% as.integer
quantified_gsm <- quantified_gsm %>% select(-gse)
quantified_gsm <- quantified_gsm %>% distinct()
quantified_gsm <- quantified_gsm %>% aggregate(nNonZeroGenes ~ gsm, data=., FUN=max)
quantified_gsm$lab <- "Mus musculus"
temp_df <- merge(temp_df, quantified_gsm, all = T)
quantified_gsm <- readRDS("C:\\Projects\\gq\\metadata\\rt_quantified.rds")
quantified_gsm$gsm <- quantified_gsm$gsm %>% str_extract("GSM\\d+")
quantified_gsm$nGenes <- quantified_gsm$nGenes %>% as.character()  %>% as.integer
quantified_gsm$nNonZeroGenes <- quantified_gsm$nNonZeroGenes %>% as.character %>% as.integer
quantified_gsm <- quantified_gsm %>% select(-gse)
quantified_gsm <- quantified_gsm %>% distinct()
quantified_gsm <- quantified_gsm %>% aggregate(nNonZeroGenes ~ gsm, data=., FUN=max)
quantified_gsm$lab <- "Rattus norvegicus"
quantified_gsm <- merge(temp_df, quantified_gsm, all = T)

########################GSM_DF############################
gsm_df <- read.csv("C:\\Projects\\gq\\metadata\\hs_seq\\gsm.tsv", sep = "\t", header = T, stringsAsFactors = F)
gsm_df$gse <- gsm_df$gse %>% str_extract("GSE\\d+")
gsm_df[is.na(gsm_df)] <- "NA"
gsm_df <- gsm_df %>% distinct()
gsm_df <- gsm_df %>% select(c(gsm, gse, organism, gpl, gsm_library_selection, gsm_library_strategy))
gsm_df$lab <- "Homo sapiens"
temp_df <- gsm_df

gsm_df <- read.csv("C:\\Projects\\gq\\metadata\\mm_seq\\gsm.tsv", sep = "\t", header = T, stringsAsFactors = F)
gsm_df$gse <- gsm_df$gse %>% str_extract("GSE\\d+")
gsm_df[is.na(gsm_df)] <- "NA"
gsm_df <- gsm_df %>% distinct()
gsm_df <- gsm_df %>% select(c(gsm, gse, organism, gpl, gsm_library_selection, gsm_library_strategy))
gsm_df$lab <- "Mus musculus"
temp_df <- gsm_df %>% merge(temp_df, ., all = T)

gsm_df <- read.csv("C:\\Projects\\gq\\metadata\\rt_seq\\gsm.tsv", sep = "\t", header = T, stringsAsFactors = F)
gsm_df$gse <- gsm_df$gse %>% str_extract("GSE\\d+")
gsm_df[is.na(gsm_df)] <- "NA"
gsm_df <- gsm_df %>% distinct()
gsm_df <- gsm_df %>% select(c(gsm, gse, organism, gpl, gsm_library_selection, gsm_library_strategy))
gsm_df$lab <- "Rattus norvegicus"
gsm_df <- gsm_df %>% merge(temp_df, ., all = T)


