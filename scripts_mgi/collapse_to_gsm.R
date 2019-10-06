#############UTILS##################
library(tidyverse)

args <- commandArgs(TRUE)

print( as.character(args[1]))
print( as.character(args[2]))
print( as.character(args[3]))
print( as.character(args[4]))
print( as.character(args[5]))

inDir <-
  as.character(args[1])

gene_mapping <- 
  as.character(args[2]) %>%
  read.csv(stringsAsFactors = F, sep = "\t")

gsm_list <-
  as.character(args[3]) %>%
  readLines() %>%
  unique

processed_gsm <-
  as.character(args[4]) %>%
  read.csv(stringsAsFactors = F, sep = "\t") %>%
  select("gsm") %>%
  unlist

srr_to_gsm <-
  as.character(args[5]) %>%
  read.csv(stringsAsFactors = F, sep = "\t")

writeProcessingStatus <-
  function(outDir, gsm, status) {
    df <- data.frame(gsm = gsm,
                     status = paste(unlist(status)))
    dfPath <- paste(outDir, "/processing.tsv", sep = "")
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

abund_files <- list.files(paste(inDir, "/", "abund", sep = ""),
                          full.names = T)

n_gsm <- length(gsm_list)

# excludiing processed GSM
gsm_list <- setdiff(gsm_list, processed_gsm)

srr_tags <-
  abund_files %>%
  str_extract("SRR\\d+")

colnames(gene_mapping) <- c("gene", "target_id")


#initializing empty gsm
temp <-
  read.table(
    abund_files[1],
    sep = "\t",
    header = T,
    stringsAsFactors = F
  ) %>%
  select(target_id, tpm)

temp$tpm <- 0

temp1 <- temp

##################EXECUTION##################
count <- length(processed_gsm)

cat(sprintf("GSM been processed: %d",
            length(processed_gsm)))

cat(sprintf("GSM left to process: %d",
            length(gsm_list)))


for (i in gsm_list) {
  tryCatch({
    cat(sprintf("%d %s \n", count, i))
    srr_list <-
      srr_to_gsm %>%
      filter(gsm == i) %>%
      select(srr) %>%
      unlist %>%
      unique
    
    # check if all necessarry SRR are present
    missing_srr <- setdiff(srr_list, srr_tags)
    
    if (identical(missing_srr, character(0))) {
      # aggregating SRR
      for (srr in srr_list) {
        srr <- paste(paste(inDir, "/abund/", srr, ".abundance.tsv", sep=""))
        srr <- 
          srr %>% 
          read.table(sep = "\t",
                     header = T,
                     stringsAsFactors = F)
        
        # converts nan tpm to 0
        srr$tpm <- as.double(srr$tpm)
        srr[is.na(srr)] <- 0
        temp$tpm <- temp$tpm + srr$tpm
      }
      
      if (sum(temp$tpm) == 0) {
        print(gsub("gsm" , i, "gsm failed quantification"))
        processingStatus <- "Failed quantification"
        writeProcessingStatus(inDir, i, processingStatus)
      } else {
        # agregating transcripts to genes
        temp <-
          merge(temp, gene_mapping, by = "target_id", all = T) %>%
          aggregate(tpm ~ gene, ., FUN = sum)
        
        write.table(
          temp,
          paste(inDir, "/GSM/", i, ".tsv", sep = ""),
          row.names = F,
          quote = F
        )
        
        print(gsub("gsm" , i, "gsm is ok"))
        processingStatus <- "ok"
        writeProcessingStatus(inDir, i, processingStatus)
      }
      
    } else {
      cat(sprintf("Missing SRR: %s \n", paste(missing_srr, collapse = " ")))
      processingStatus <-
        paste(c("Missing SRR:", missing_srr), collapse = " ")
      writeProcessingStatus(inDir, i, processingStatus)
    }
    
    temp <- temp1
    count <- count + 1
  },
  error = function(e)
  {
    cat(sprintf("Error occurd while processing %s: %s \n", i, e$message))
    
    writeProcessingStatus(inDir, i,  e$message)
  })
}
