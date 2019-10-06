#################################################ARGUMENTS#######################
args <- commandArgs(TRUE)

pathIn <- as.character(args[1]) 
outFile <- as.character(args[2])

##############################################EXECUTION##########################
library(tidyverse)
library(stringr)

files <- list.files(pathIn, full.names = TRUE)
files <- files[grepl(".result.csv", files)]

set_df <- tibble()
for (file in files){
  print(file)
  pathName <- file %>% str_match(., "(.*?).result.csv") %>% .[,2]
  temp_df <- read.csv(file, sep = "\t") 
  if (temp_df %>% nrow > 0){
    set_df <- temp_df %>% cbind(., pathName) %>% rbind(set_df, .)
  }
}

saveRDS(set_df,file=outFile)