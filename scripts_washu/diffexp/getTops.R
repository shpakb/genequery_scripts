###########GET_TOPS####################
#################################################ARGUMENTS#######################
args <- commandArgs(TRUE)

pathIn <- as.character(args[1])
nGenes <- as.integer(args[2])
organism <- as.character(args[3])

print(nGenes)

###################################################EXECUTION######################
library(tidyverse)

diffexpPath <- paste(pathIn, "/diffexp", sep = "")

print(diffexpPath)

files <- list.files(diffexpPath, full.names = TRUE)

for (file in files) {
  df <- read.csv(file, sep = "\t", stringsAsFactors = F)
  
  label <-
    str_match(file, "(GSE.*?)\\.de.tsv")[,2]# example ".time.48_h.24_h."
  
  filename <-
    c(label, "_up_", nGenes, ".list") %>%
    paste(., collapse = "") %>%
    gsub(",", "_", .)

  
  up <- df[1:nGenes, 1]
  

  write(c(organism, organism, up), paste(pathIn, "/geneSets/", filename, sep = ""))
  
  pVal_df <- tibble(
    filename = filename,
    meanAdjP = mean(df$adj.P.Val[1:nGenes]),
    medianAdjP = median(df$adj.P.Val[1:nGenes]),
    meanLogAdjP = mean(log10(df$adj.P.Val[1:nGenes])),
    medianLogAdjP = median(log10(df$adj.P.Val[1:nGenes])),
    meanP = mean(df$P.Value[1:nGenes]),
    medianP = median(df$P.Value[1:nGenes]),
    meanLogP = mean(log10(df$P.Value[1:nGenes])),
    medianLogP = median(log10(df$P.Value[1:nGenes])),
    meanT = mean(log10(df$t[1:nGenes])),
    medianT = median(log10(df$t[1:nGenes]))
  )
  dfPath <- paste(pathIn, "/diffexpPVals.tsv", sep = "")
  write.table(
    x = pVal_df,
    file = dfPath,
    sep = "\t",
    col.names = !file.exists(dfPath),
    row.names = F,
    append = T,
    quote = F
  )
  
  # down genes
  dn <-
    df[(nrow(df) - nGenes+1):nrow(df), 1]
  filename <-
    c(label, "_dn_", nGenes, ".list")%>%
    paste(., collapse = "") %>%
    gsub(",", "_", .)
  write(c(organism, organism, dn), paste(pathIn, "/geneSets/", filename, sep = ""))
  
  pVal_df <- tibble(
    filename = filename,
    meanAdjP = mean(df$adj.P.Val[(nrow(df) - nGenes+1):nrow(df)]),
    medianAdjP = median(df$adj.P.Val[(nrow(df) - nGenes+1):nrow(df)]),
    meanLogAdjP = mean(log10(df$adj.P.Val[(nrow(df) - nGenes+1):nrow(df)])),
    medianLogAdjP = median(log10(df$adj.P.Val[(nrow(df) - nGenes+1):nrow(df)])),
    meanP = mean(df$P.Value[(nrow(df) - nGenes+1):nrow(df)]),
    medianP = median(df$P.Value[(nrow(df) - nGenes+1):nrow(df)]),
    meanLogP = mean(log10(df$P.Value[(nrow(df) - nGenes+1):nrow(df)])),
    medianLogP = median(log10(df$P.Value[(nrow(df) - nGenes+1):nrow(df)])),
    meanT = mean(log10(df$t[(nrow(df) - nGenes+1):nrow(df)])),
    medianT = median(log10(df$t[(nrow(df) - nGenes+1):nrow(df)]))
  )
  
  dfPath <- paste(pathIn, "/diffexpPVals.tsv", sep = "")
  write.table(
    x = pVal_df,
    file = dfPath,
    sep = "\t",
    col.names = !file.exists(dfPath),
    row.names = F,
    append = T,
    quote = F
  )
}