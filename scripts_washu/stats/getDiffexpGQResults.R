library(tidyverse)

args <- commandArgs(TRUE)

pathIn <- as.character(args[1]) 
pathOut <- as.character(args[2]) 

files <- list.files(pathIn, full.names = TRUE)
files <- files[grepl(".list.result.csv", files)]
print(length(files))

result_df <- tibble(GSE="deletethisrow",
                    GPL="deletethisrow",
                    isUp200=TRUE,
                    moduleNumber = 0,
                    logPvalue = 0,
                    logAdjPvalue = 0,
                    intersectionSize = 0,
                    moduleSize = 0, 
                    title = "NA",
                    bestPosition = 0,
                    deCond = "NA",
                    outputSize = 0,
                    timesFound = 0)

for (file in files){
  print(file)
  df <- read.delim(file)
  gse <- str_extract(file, "GSE(.\\d+)")
  gpl <- str_extract(file, "GPL(.\\d+)")
  deCond <- file %>% str_match(., "GPL\\d+.(.*)(.dn_200|.up_200)") %>% .[,2]
  isUp200 <- grepl("up_200", file)
  outputSize <- nrow(df)
  
  if (nrow(df) > 0) {
    df$bestPosition <- 1:nrow(df)
    df <- df[df$GSE==gse & df$GPL==gpl,]
    if (nrow(df) > 0){
      intersectionSize <- df$intersectionSize[1]
      bestPosition <- df$bestPosition[1]
      timesFound <- nrow(df)
      moduleNumber <- df$moduleNumber[1]
      logPvalue <- df$logPvalue[1]
      logAdjPvalue <- df$logAdjPvalue[1]
      moduleSize <- df$moduleSize[1]
      title <- df$title[1]
    } else {
      intersectionSize <- 0
      bestPosition <- 0
      timesFound <- 0
      moduleNumber <- 0
      logPvalue <- 0
      logAdjPvalue <- 0
      moduleSize <- 0
      title <- "NA"
    } 
  } else {
    intersectionSize <- 0
    bestPosition <- 0
    timesFound <- 0
    moduleNumber <- 0
    logPvalue <- 0
    logAdjPvalue <- 0
    moduleSize <- 0
    title <- "NA"
  }

  result_df <- rbind(result_df, 
        tibble(GSE=gse,
               GPL=gpl,
               isUp200=isUp200,
               moduleNumber = moduleNumber,
               logPvalue = logPvalue,
               logAdjPvalue = logAdjPvalue,
               intersectionSize = intersectionSize,
               moduleSize = moduleSize,
               title = title,
               bestPosition = bestPosition,
               deCond = deCond,
               outputSize = outputSize,
               timesFound = timesFound))
}

result_df <- result_df[2:nrow(result_df),]

saveRDS(result_df, pathOut)