#################################################ARGUMENTS#######################
args <- commandArgs(TRUE)

tag <- as.character(args[1])
inDir <- as.character(args[2])
outDir <- as.character(args[3])
nGenes <- as.integer(args[4])

#################################################UTILS#######################
library(tidyverse)
library(limma)
library(data.table)

max2 = function(array) {
  n = length(array)
  sort(array, partial = n - 1)[n - 1]
}

is_logscale <- function(x) {
  qx <- quantile(as.numeric(as.matrix(x)), na.rm = T)
  if (qx[5] - qx[1] > 100 || qx[5] > 100) {
    return(FALSE)
  } else {
    return(TRUE)
  }
}

linearizeDataset <- function(ge) {
  if (is_logscale(ge))
    return(2 ^ ge - 1)
  return(ge)
}

logDataset <- function(ge) {
  if (is_logscale(ge))
    return(ge)
  return(log2(ge + 1))
}

limma_gds <-
  function(exp,
           cond_table,
           column,
           cond1,
           cond2,
           pathOut,
           tag) {
    design <-
      cbind(as.numeric(cond_table[, column] == cond1),
            as.numeric(cond_table[, column] == cond2))
    
    colnames(design) <- c("cond1", "cond2")
    print(design)
    
    contrasts_formula <-  "cond2 - cond1"
    
    contrast <-
      makeContrasts(contrasts = contrasts_formula, levels = design)
    
    # subsetting
    exp <- exp[, rowSums(design) > 0]
    design <- design[rowSums(design) > 0, ]
    
    fit <- lmFit(exp, design)
    fit <-  contrasts.fit(fit, contrast)
    
    # empirical Bayes adjustment
    fit <- eBayes(fit)
    
    diffexp <- topTable(fit, coef = 1, n = Inf)
    
    diffexp <- diffexp[order(diffexp$t, decreasing = TRUE),]
    
    # apperantly there are some gene discriptions with \t and \n...
    diffexp$Symbol <-
      diffexp %>%
      rownames() %>%
      gsub("\t", "", .) %>%
      gsub("\n", "", .)
    
    diffexp <- diffexp[, c(7, 1, 2, 3, 4, 5, 6)]
    
    #fix white space at the start of file name
    filename <-
      c(tag, column, cond1, cond2, "de", "tsv") %>%
      paste(collapse = ".") %>%
      paste(pathOut, "/diffexp/", ., collapse = "") %>% 
      gsub(" ", "", .)
    
    print(filename)
    
    write.table(
      diffexp,
      filename,
      quote = FALSE,
      sep = "\t",
      eol = "\n",
      row.names = FALSE
    )
  }

mass_limma_gds <- function(tag, pathIn, pathOut, nGenes) {
  expMatFile <- paste(outDir, "/matrices/", tag, ".tsv", sep = "")
  print(expMatFile)
  # exit if no file
  if (!file.exists(expMatFile)){
    return(NULL)
  }
  ## there's a stupid probe name with a #, it gets disabled with comment.char=""
  exp <-
    expMatFile %>%
    read.table(
      comment.char = "",
      header = T,
      sep = "\t",
      fill = T,
      check.names = F
    )
  
  cond <-
    paste(pathIn, "/cond/", tag, sep = "") %>%
    read.table(header = T, row.names = 1)
  
  pairs <-
    paste(pathIn, "/contrast/", tag, sep = "") %>%
    fread()
  
  
  exp$max2 <- apply(exp, 1, FUN = max2)
  exp        <- exp[order(exp$max2, decreasing = T),]
  exp        <- exp[1:nGenes,]
  exp$max2   <- NULL
  
  # cleaning sample annotation  
  colnames(exp) <- colnames(exp) %>% str_extract("GSM\\d+")
  
  # usually GDS is a sample of GSE samples. Subsetting
  exp <- exp[, colnames(exp) %in% rownames(cond)]
  
  # Align cond and exp sample order
  exp <- exp[, rownames(cond)]
  
  for (i in 1:nrow(pairs))
  {
    tryCatch({
      column <- pairs$Column[i]
      cond1  <- pairs$cond1[i]
      cond2  <- pairs$cond2[i]
      
      limma_gds(exp, cond, column, cond1, cond2, pathOut, tag)
    }, error = function(e) {
      
    })
  }
}

mass_limma_gds(tag, inDir, outDir, nGenes)
