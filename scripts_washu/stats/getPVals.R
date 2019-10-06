#################################################ARGUMENTS#######################
args <- commandArgs(TRUE)

pathIn <- as.character(args[1]) 
pathOut <- as.character(args[2])
nGenes <- as.integer(args[3])
sort <- as.character(args[4])


###################################################EXECUTION######################
library(tidyverse)

# get the convertion table
hs_conv <- read.csv("~/gq/data/hs.gds_to_gse.tsv", "\t", header = FALSE) %>% cbind(., "hs") 
colnames(hs_conv) <- c("gds", "label", "species")
mm_conv <- read.csv("~/gq/data/mm.gds_to_gse.tsv", "\t", header = FALSE) %>% cbind(., "mm") 
colnames(mm_conv) <- c("gds", "label", "species")
rt_conv <- read.csv("~/gq/data/rt.gds_to_gse.tsv", "\t", header = FALSE) %>% cbind(., "rt") 
colnames(rt_conv) <- c("gds", "label", "species")

conv_table <- rbind(hs_conv, mm_conv, rt_conv)
conv_table$label <- conv_table$label %>% as.character()
conv_table$species <- conv_table$species %>% as.character()


files <- list.files(pathIn, full.names = TRUE)
files <- files[!(grepl(".error", files))]


# getting mean p-value for 200 DE genes
pValue_df <- tibble(filename=NA,
                    meanAdjP=NA,
                    medianAdjP=NA,
                    meanLogAdjP=NA,
                    medianLogAdjP=NA,
                    meanP=NA,
                    medianP=NA,
                    meanLogP=NA,
                    medianLogP=NA)

for (file in files) {
  print(file)
  tag <- str_extract(file, "GDS\\d+")
  label <- conv_table[conv_table$gds == tag,2]
    

    print(file)

    df <- read.csv(file, sep = "\t")
    # reordering if necessary. logFold ordering is default.
    if (sort == "t") {
      df <- df[order(df$t, decreasing = T),]
    }

    condition <- str_match(file, "GDS\\d+(.*?)de.tsv")[2] # example ".time.48_h.24_h."
    
    filename <- c(label, condition, "up_", nGenes, ".list") %>% paste(., collapse = "") %>% gsub(",", "_", .)
    pValue_df <- rbind(pValue_df, c(filename, 
                                    mean(df$adj.P.Val[1:nGenes]), 
                                    median(df$adj.P.Val[1:nGenes]), 
                                    mean(log10(df$adj.P.Val[1:nGenes])), 
                                    mean(log10(df$adj.P.Val[1:nGenes])),
                                    mean(df$P.Value[1:nGenes]), 
                                    median(df$P.Value[1:nGenes]), 
                                    mean(log10(df$P.Value[1:nGenes])), 
                                    mean(log10(df$P.Value[1:nGenes])) ))

    filename <- c(label, condition, "dn_", nGenes, ".list") %>% paste(., collapse = "") %>% gsub(",", "_", .)
    pValue_df <- rbind(pValue_df, c(filename, 
                                    mean(df$adj.P.Val[(nrow(df)-nGenes):nrow(df)]), 
                                    median(df$adj.P.Val[(nrow(df)-nGenes):nrow(df)]), 
                                    mean(log10(df$adj.P.Val[(nrow(df)-nGenes):nrow(df)])), 
                                    median(log10(df$adj.P.Val[(nrow(df)-nGenes):nrow(df)])),
                                    mean(df$P.Value[(nrow(df)-nGenes):nrow(df)]), 
                                    median(df$P.Value[(nrow(df)-nGenes):nrow(df)]), 
                                    mean(log10(df$P.Value[(nrow(df)-nGenes):nrow(df)])), 
                                    median(log10(df$P.Value[(nrow(df)-nGenes):nrow(df)])) ))
}


saveRDS(pValue_df, pathOut)