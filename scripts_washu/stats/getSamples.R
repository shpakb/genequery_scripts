args <- commandArgs(TRUE)

pathIn <- as.character(args[1]) 
pathOut <- as.character(args[2])

library(tidyr)
library(stringr)

files <- list.files(path = pathIn, full.names = T)

result <- data.frame(gsm=character(),
                     gse=character(),
                     nNonZeroGenes=integer())

for (file in files) {
  gse <- file %>% str_extract("GSE\\d+\\-GPL\\d+|GSE\\d+")
  print(gse)

  # apperantly there are some matrices without samples and even empty files 
  if (file.size(file) > 0){
    df <- read.csv(file, sep="\t")
    gsm <- colnames(df)[4:ncol(df)] %>% str_extract("GSM\\d+")
    nGenes <- nrow(df)
    # lets try something above 0 so that noise is taken away
    nNonZeroGenes <- colSums(df[4:ncol(df)] >= 2) %>% unname
    result <- cbind(gsm, gse, nGenes, nNonZeroGenes) %>% rbind(result)
    } else {
      gsm <- NA
      nGenes <- NA
      nNonZeroGenes <- NA
      result <- c(gsm, gse, nNonZeroGenes) %>% rbind(result)
      }
}
saveRDS(object = result, file = pathOut)