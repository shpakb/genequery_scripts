library(tidyverse)

args <- commandArgs(TRUE)

inDir <-
  as.character(args[1])

writeProcessingStatus <-
  function(gsm, n_exp_genes) {
    df <- data.frame(gsm = gsm,
                     status = n_exp_genes)
    dfPath <- paste(inDir, "/n_exp_genes.tsv", sep = "")
    write.table(
      x = df,
      file = dfPath,
      sep = "\t",
      col.names = !file.exists(dfPath),
      row.names = F,
      append = T,
      quote = F
    )
  }


files <- paste(inDir, "/GSM", sep="") %>%
  list.files()

processed_gsm <- 
  paste(inDir, "/n_exp_genes.tsv", sep = "") %>% 
  read.csv(sep = "\t") %>% 
  select(gsm) %>% 
  unlist %>% 
  unique
  
gsms <- files %>% str_extract("GSM\\d+")
gsms <- setdiff(gsms, processed_gsm)

count <- length(processed_gsm)

for (gsm in gsms){
  f <- paste(inDir, "/GSM/", gsm, ".tsv", sep="")
    
  df <- read.csv(f, sep=" ")
  
  writeProcessingStatus(gsm, sum(df$tpm != 0))
  
  # rewrites original files to proper tsv
  write.table(
          df,
          f,
          sep = "\t",
          row.names = F,
          quote = F
        )
  count <- count + 1 
  print(count)
  print(gsm)
}