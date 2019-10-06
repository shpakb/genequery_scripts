###################GDS_TO_COND_EXP#############################
args <- commandArgs(TRUE)

pathIn <- as.character(args[1])
pathOut <- as.character(args[2])
organism <- as.character(args[3])

library(tidyverse)

writeGDSStats <-
  function(dtPath,
           gds,
           lab,
           n_gsm,
           n_var,
           n_cond,
           n_comp) {
    df <- data.frame(gds,
                     lab,
                     n_gsm,
                     n_var,
                     n_cond,
                     n_comp)
    
    write.table(
      x = df,
      file = dtPath,
      sep = "\t",
      col.names = !file.exists(dtPath),
      row.names = F,
      append = T,
      quote = F
    )
  }

files <- list.files(pathIn, full.names = T)
dtPath <- paste(pathOut, "/gdsStats.csv", sep = "")

for (file in files) {
  tryCatch({
    in.con <- gzfile(file)
    gds <- file %>% str_extract("(GDS\\d+)")
    
    # parsing file
    text <- readLines(in.con)
    
    # getting corresponding GSE ID
    gse <-
      text[which(grepl("!dataset_reference_series = ", text))] %>% str_extract("GSE\\d+")
    gpl <-
      text[which(grepl("!dataset_platform = ", text))] %>% str_extract("GPL\\d+")
    lab <- paste(gse, "_", gpl, sep = "")
    
    state <-
      text %>%
      str_extract_all("!subset_description = (.*)") %>%
      unlist %>%
      gsub("!subset_description = ", "", .) %>%
      gsub("/|? |?,|?\\.|-", "_", .) %>%
      gsub("_{2,}", "_", .)
    gsm <-
      text %>% str_extract_all("!subset_sample_id = (.*)") %>%
      unlist %>%
      gsub("!subset_sample_id = ", "", .) %>%
      str_extract_all("(GSM\\d+)")
    var <-
      text %>%
      str_extract_all("!subset_type = (.*)") %>%
      unlist %>%
      gsub("!subset_type = ", "", .) %>%
      gsub("/|? |?,|?\\.|-", "_", .) %>%
      gsub("_{2,}", "_", .)
    
    n_gsm <- gsm %>% unlist %>% unique %>% length
    
    df <- data.frame(gsm = character(),
                     var = character(),
                     state = character())
    
    # dataframe with all sample condition relationsips
    for (i in 1:length(gsm))
    {
      df <- data.frame(
        gsm = gsm[[i]],
        var = var[i],
        state = state[i],
        stringsAsFactors = F
      ) %>% rbind(df)
    }
    
    vars <- df$var %>% unique()
    
    # contrast dataframe
    contrast <- data.frame(Column = character(),
                           cond1 = character(),
                           cond2 = character())
    
    for (var in vars)
    {
      pairs <-
        df[df$var == var, 3] %>%
        unique() %>%
        combn(2)
      
      for (i in 1:ncol(pairs))
      {
        temp <- data.frame(Column = var,
                           cond1 = pairs[1, i],
                           cond2 = pairs[2, i])
        contrast <-  rbind(contrast, temp)
      }
    }
    
    # expression table
    tableStart <- which(grepl("!dataset_table_begin", text))
    tableEnd <- which(grepl("!dataset_table_end", text))
    
    exp <-
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
    
    # condition table
    cond <-
      reshape(
        df,
        direction = "wide",
        idvar = c("gsm"),
        timevar = c("var")
      )
    
    colnames(cond) <-
      colnames(cond) %>%
      gsub("gsm", "Sample_ID", .) %>%
      gsub("state\\.", "", .)
    
    exp %>% write.table(
      paste(pathOut, "/exp/", lab, sep = ""),
      sep = "\t",
      quote = F,
      row.names = F
    )
    cond %>%  write.table(
      paste(pathOut, "/cond/", lab, sep = ""),
      sep = "\t",
      quote = F,
      row.names = F
    )
    contrast %>% write.table(
      paste(pathOut, "/contrast/", lab, sep = ""),
      sep = "\t",
      quote = F,
      row.names = F
    )
    
    writeGDSStats(
      dtPath,
      gds = gds,
      lab = lab,
      n_gsm = gsm %>% unlist() %>% unique() %>% length(),
      n_var = ncol(cond) - 1,
      n_cond = length(state),
      n_comp = nrow(contrast)
    )
  },
  error = function(e)
  {
    writeGDSStats(
      dtPath,
      gds = gds,
      lab = lab,
      n_gsm = NA,
      n_var = NA,
      n_cond = NA,
      n_comp = NA
    )
  })
}