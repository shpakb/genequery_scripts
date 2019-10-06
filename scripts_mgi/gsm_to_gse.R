library(tidyverse)

args <- commandArgs(TRUE)

inDir <-
  as.character(args[1])

gse_table <- 
  as.character(args[2]) %>% 
  read.csv(stringsAsFactors = F)

print(gse_table %>% dim())

geneAnnot <- 
  as.character(args[3]) %>%
  read.csv(stringsAsFactors = F, 
           sep = "\t",
           header = F) %>% 
  filter(V3!="NONE")

colnames(geneAnnot) <- c("gene", "symbol", "entrez")

count <- 0

gse_list <- 
  gse_table$gse %>% 
  unique

for (i in gse_list){
  
  gsm_list <-
    gse_table %>%
    filter(gse==i) %>%
    select(gsm) %>%
    unlist %>% 
    unique
  
  gse <-
    paste(inDir, "/GSM/", gsm_list[1], ".tsv", sep="") %>% 
    read.csv(sep = "\t") %>% 
    select(gene)
  
  for (j in 1:length(gsm_list)){
  
    gsm <- paste(inDir, "/GSM/", gsm_list[j], ".tsv", sep="") %>% 
      read.csv(sep = "\t",
               stringsAsFactors = F)
  
    gse <- 
      gse %>% 
      cbind(gsm$tpm)
    print(gsm_list[j])
    colnames(gse)[j+1] <- gsm_list[j]
  }
  
  gse <- 
    merge(gse, geneAnnot) %>%
    select(-c("symbol", "gene"))  %>% 
    select("entrez", everything())
  
  # rewrites original files to proper tsv
  write.table(x =   gse,
          file = paste(inDir, "/GSE/", i, ".tsv", sep=""),
          sep = "\t",
          row.names = F,
          quote = F
        )
  count <- count + 1 
  print(count)
  print(i)
}