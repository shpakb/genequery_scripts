####################################ARGUMENTS#########################
args <- commandArgs(TRUE)

inFile <- as.character(args[1])
outDir <- as.character(args[2])
gplDir <- as.character(args[3])
nGenes <- as.integer(args[4])
ct <- as.character(args[5])
logScaleF <- as.logical(args[6])
quantileF <- as.logical(args[7])

# Outs needed
expMatF <- as.logical(args[8])
modulesF <- as.logical(args[9])
eigengenesF <- as.logical(args[10])
svgF <- as.logical(args[11])

cat(sprintf("Processing: %s\n", inFile))
cat(sprintf(
  "Log normalization: %s; Quantile normalization: %s\n",
  logScaleF,
  quantileF
))
cat(sprintf(
  "Top %d most expressed genes will be considered; corType = %s\n",
  nGenes,
  ct
))
cat(
  sprintf(
    "Expression Matrix: %s; Modules: %s; Eigengenes: %s; SVG-plots: %s\n",
    expMatF,
    modulesF,
    eigengenesF,
    svgF
  )
)
####################################UTILS#############################
library(WGCNA)
library(stringr)
library(tidyverse)
library(reshape)
library(svglite)
library(limma)

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

is_logscale <- function(x) {
  qx <- quantile(as.numeric(x), na.rm = T)
  if (qx[5] - qx[1] > 100 || qx[5] > 100) {
    return(FALSE)
  } else {
    return(TRUE)
  }
}

max2 = function(array) {
  n = length(array)
  sort(array, partial = n - 1)[n - 1]
}

eigenorm = function (val, min, max) {
  if (min == 0 | max == 0)
    stop ("Line minimum or a maximum equal to 0")
  if (val <= 0) {
    return(round(val / abs(min), digits = 3))
  } else {
    return(round(val / max, digits = 3))
  }
}

exvector = function (v) {
  min = min(v)
  max = max(v)
  for (i in 1:length(v)) {
    if (v[i] <= 0) {
      v[i] = round(v[i] / abs(min), digits = 3)
    } else {
      v[i] = round(v[i] / max, digits = 3)
    }
  }
  return(v)
}

replaceWithNa <- function(x, ...) {
  if (length(x) == 0)
    return(NA)
  return(x)
}

readGPLTable <- function(gpl) {
  df <-
    read.table(
      gzfile(gpl),
      sep = "\t",
      comment.char = "",
      stringsAsFactors = F
    )
  
  column <- df$V3 %>% str_extract_all("(\\d+)")
  indx <-
    column %>%
    lapply(as.integer) %>%
    lapply(which.min) %>%
    lapply(replaceWithNa) %>%
    unlist
  
  df$V3 <-
    lapply(1:length(column), function(x)
      column[[x]][indx[x]]) %>% unlist
  
  column <- strsplit(df$V2, "///")
  df$V2 <-
    lapply(1:length(column), function(x)
      column[[x]][indx[x]]) %>% unlist
  
  df[is.na(df)] <- "NONE"
  
  rownames(df) <- df$V1
  colnames(df) <- c("Probe_id", "Symbol", "Entrez_ID")
  
  df
}

wgcna_preprocessed = function(exp, ct) {
  nGenes <- nrow(exp)
  texp <- t(exp)
  pwrs <- c(5:25)
  
  sft <-
    pickSoftThreshold(
      texp,
      powerVector = pwrs,
      verbose = 3,
      networkType = "signed hybrid",
      corFnc = if (ct == "bicor")
        bicor
      else
        cor
    )
  
  #picking best power
  i <- 1
  p <- NA
  cutoffs <- seq(0.9, 0, -0.1)[1:3]
  while ((is.na(p) | is.infinite(p)) & i < 4) {
    p <-
      sft$fitIndices$Power[sft$fitIndices$SFT.R.sq > cutoffs[i]] %>% min
    i <- i + 1
  }
  
  if ((is.na(p) | is.infinite(p))) {
    return(NULL)
  }
  
  ncut <- if (p <= 10)
    0.25
  else
    0.15
  
  net <-
    blockwiseModules(
      texp,
      power = p,
      minModuleSize = 50 ,
      reassignThreshold = 0,
      mergeCutHeight = ncut,
      corType = ct,
      maxBlockSize = nGenes,
      deepSplit = 4,
      numericLabels = T,
      pamRespectsDendro = F,
      networkType = "signed hybrid",
      verbose = 0
    )
  
  if (!is.null(net)) {
    eigengenes <- t(net$MEs)
    colnames(eigengenes) <- colnames(exp)
    
    return(list(
      modules = cbind(rownames(exp), net$colors),
      eigengenes = eigengenes,
      powerChosen = p
    ))
    
  } else {
    return(NULL)
  }
}

make_svg_heatmaps = function (eigenData, tag, outDir) {
  ## With non-renamed/non-normalized eigengene tables.
  requireNamespace("ggplot2")
  requireNamespace("reshape")
  
  tt <- eigenData
  rownames(tt) <- as.numeric(gsub("ME", "", rownames(tt)))
  tts <- tt[order(as.numeric(rownames(tt))),]
  tts2 <- tts[, order(colnames(tts))]
  ttn <- as.data.frame(t(apply(tts2, 1, FUN = exvector)))
  ttn$Module <- rownames(ttn)
  
  nsmp <- ncol(tt)
  nmod <- nrow(tt) - 1 ## number of non-zero modules
  tt.m <- melt(ttn)
  
  names(tt.m) <- c("Module", "Sample", "value")
  ## the following are very important
  tt.m$Module <- as.factor(tt.m$Module)
  sorted_labels <- paste(sort(as.integer(levels(tt.m$Module))))
  tt.m$Module <- factor(tt.m$Module, levels = sorted_labels)
  tt.m$Sample <-
    with(tt.m, factor(Sample, levels = rev(sort(unique(
      Sample
    )))))
  
  ## let's evaluate SVG dimensions. We want constant width of 10 in.
  title_length <- max(nchar(colnames(tt)))
  svg_height  <- round((10 / 27.1) * nsmp, digits = 3)
  svg_width <-
    round((10 / 27.1) * (0.25 * title_length + nmod + 1), digits =
            3)
  cat (
    sprintf(
      "Longest sample title is %d characters, there are %d samples and %d modules, plot width is %f, height is %f\n",
      title_length,
      nsmp,
      nmod,
      svg_width,
      svg_height
    )
  )
  
  base_size <- 9
  for (i in 0:nmod) {
    ## special type of coloring for easier heatmap reading. Can be adjusted.
    p <-
      ggplot(tt.m, aes(Module, Sample)) + geom_tile(aes(fill = value), colour = "black", size =
                                                      0.5) + scale_fill_gradientn(colours = c("blue", "blue", "white", "red", "red"),
                                                                                  space = "Lab")
    p2 <-
      p + theme_grey(base_size = base_size) + labs(x = "", y = "") + scale_x_discrete(expand =
                                                                                        c(0, 0)) + scale_y_discrete(expand = c(0, 0)) + theme(
                                                                                          legend.position = "none",
                                                                                          axis.text.y = element_text(size = base_size * 1.2, colour = "black"),
                                                                                          axis.text.x = element_text(size = base_size * 1.2, colour = "black")
                                                                                        )
    xmin <- i + 0.5
    xmax <- i + 1.5
    ymin <- 0.5
    ymax <- nsmp + 0.5
    rect <- data.frame(
      xmin = xmin,
      xmax = xmax,
      ymin = ymin,
      ymax = ymax
    )
    p3 <-
      p2 + geom_rect(
        data = rect,
        aes(
          xmin = xmin,
          xmax = xmax,
          ymin = ymin,
          ymax = ymax
        ),
        color = "black",
        fill = "grey",
        alpha = 0,
        size = 3,
        inherit.aes = F
      )
    svgname <- paste(tag, "_module_", i, ".svg", sep = "")
    ##cat(sprintf("Processing module number %d, saving file %s\n",i,svgname))
    ggsave(
      file = paste(outDir, svgname, sep = ""),
      plot = p3,
      width = svg_width,
      height = svg_height,
      limitsize = F
    )
  }
}

writeProcessingStatus <-
  function(outDir, file, tag, status, power, nGenes) {
    file <-
      file %>% str_extract("GSE\\d+\\-GPL\\d+_series_matrix.txt.gz|GSE\\d+_series_matrix.txt.gz")
    df <- data.frame(
      tag = tag,
      file = file,
      processingStatus = status,
      power = power,
      nGenes = nGenes
    )
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

############################################EXECUTION###########################
tryCatch({
  in.con <- gzfile(inFile)
  wholeFile <- readLines(in.con)
  processingStatus <- "proceed"
  
  gplId <- which(grepl("!Sample_platform_id", wholeFile))
  gplId <- gsub(".*(GPL\\d+).*", "\\1", wholeFile[gplId])
  gpl <-  paste(c(gplDir, "/", gplId, ".3col.gz"), collapse = "")
  
  # it is necessary that tag has gpl
  tag <- inFile %>% str_extract("GSE\\d+")
  tag <- paste(c(tag, "_", gplId), collapse = "")
  
  if (!file.exists(gpl))
  {
    processingStatus <-
      gsub("gplId", gplId, "Failed. gplId is not supported.")
    writeProcessingStatus(outDir, inFile, tag, processingStatus, NA, NA)
  } else {
    isSuperSeries <- grepl("SuperSeries of", wholeFile) %>% any()
    
    if (isSuperSeries)
    {
      processingStatus <-
        gsub("tag", tag, "Failed. tag is a superseries.")
      writeProcessingStatus(outDir, inFile, tag, processingStatus, NA, NA)
    } else {
      sampleTitleId <- which(grepl("!Sample_title", wholeFile))
      sampleTitles <- strsplit(wholeFile[sampleTitleId], "\t")
      sampleTitles <-
        sampleTitles[[1]][2:(length(sampleTitles[[1]]))]
      sampleTitles <- gsub("\"", "", sampleTitles)
      
      tableStart <-
        which(grepl("!series_matrix_table_begin", wholeFile))
      tableEnd <-
        which(grepl("!series_matrix_table_end", wholeFile))
      expressionTable <-
        read.table(
          in.con,
          sep = "\t",
          header = 1,
          row.names = 1,
          comment.char = "",
          skip = tableStart,
          nrows = tableEnd - tableStart - 2,
          stringsAsFactors = F
        )
      expressionTable <- as.matrix(expressionTable)
      colnames(expressionTable) <-
        mapply(
          colnames(expressionTable),
          sampleTitles,
          FUN = function(x, y)
            sprintf("%s_%s", x, y)
        )
      
      if (ncol(expressionTable) < 8 |
          ncol(expressionTable) > 200)
      {
        processingStatus <-
          "Failed due to number of samples been out of range"
        writeProcessingStatus(outDir, inFile, tag, processingStatus, NA, NA)
      } else {
        exp <- linearizeDataset(expressionTable)
        explog <- logDataset(expressionTable)
        
        logav <- mean(explog)
        logmax <- max(explog)
        linmax <- max(exp)
        
        if (!(!any(is.na(c(
          logav, logmax, linmax
        ))) &&
        logav >= 4 &&
        logav <= 10 &&
        linmax >= 2000 &&
        logmax < 20))
        {
          processingStatus <- "Failed sanity check"
          writeProcessingStatus(outDir, inFile, tag, processingStatus, NA, NA)
        } else {
          # Quantile normalization
          if (quantileF)
          {
            exp <-
              normalizeBetweenArrays(exp, method = "quantile")
          }
          
          gplTable <- readGPLTable(gpl)
          
          exp <- cbind(gplTable[rownames(exp), ], exp)
          
          exp <-
            exp[!(row.names(exp) %in% c("NONE", "NA", "none", "NULL")), ]
          
          exp <-
            collapseRows(exp[4:ncol(exp)], exp$Entrez_ID, rownames(exp))
          
          exp <- exp$datETcollapsed
          
          exp <-
            exp[!(row.names(exp) %in% c("NONE", "NA", "none", "NULL")),]
          
          if (logScaleF)
          {
            exp <- logDataset(exp)
          }
          
          exp <- as.data.frame(exp)
          
          if (nrow(exp) < nGenes) {
            processingStatus <- "Insufficient number of genes after colapsing"
            writeProcessingStatus(outDir, inFile, tag, processingStatus, NA, nGenes)
          } else {
            exp$max2 <- apply(exp, 1, FUN = max2)
            exp <- exp[order(exp$max2, decreasing = T), ]
            exp <- exp[1:nGenes, ]
            exp$max2 <- NULL
            # Doing WGCNA
            wgcnaOut <- wgcna_preprocessed(exp, ct)
            
            if (is.null(wgcnaOut))
            {
              processingStatus <- "Failed WGCNA"
              writeProcessingStatus(outDir, inFile, tag, processingStatus, NA, nGenes)
            } else {
              if (expMatF)
              {
                write.table(
                  exp,
                  file = paste(outDir, "/matrices/", tag, ".tsv", sep = ""),
                  quote = F,
                  col.names = T,
                  row.names = T,
                  sep = "\t"
                )
              }
              
              if (modulesF)
              {
                write.table(
                  wgcnaOut$modules,
                  file = paste(outDir, "/modules/", tag, ".tsv", sep = ""),
                  quote = F,
                  col.names = F,
                  row.names = F,
                  sep = "\t"
                )
              }
              if (eigengenesF)
              {
                write.table(
                  wgcnaOut$eigengenes,
                  file = paste(outDir, "/eigengenes/", tag, ".tsv", sep = ""),
                  quote = F,
                  col.names = T,
                  row.names = T,
                  sep = "\t"
                )
              }
              
              if (svgF)
              {
                svg_path <- paste(c(outDir, "/heatmaps/", tag, "/"), collapse = "")
                dir.create(svg_path)
                make_svg_heatmaps(wgcnaOut$eigengenes,
                                  tag,
                                  svg_path)
              }
              
              processingStatus <- "OK"
              writeProcessingStatus(outDir,
                                    inFile,
                                    tag,
                                    processingStatus,
                                    wgcnaOut$power,
                                    nGenes)
            }
          }
        }
      }
    }
  }
},
error = function(e)
{
  cat(sprintf("Dataset %s failed\n", tag))
  processingStatus <-
    gsub("1err1", e$message, "Error occured: 1err1")
  writeProcessingStatus(outDir, inFile, tag, processingStatus, NA, nGenes)
})
