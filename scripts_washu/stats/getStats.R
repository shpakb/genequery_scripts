#################################################ARGUMENTS#######################
args <- commandArgs(TRUE)

dataPath <- as.character(args[1]) 
modulesPath <- as.character(args[2])

##############FUNCTIONS#######################
library(tidyverse)
library(stringr)

readModules <- function(file){
  modules <- readLines(file)
  number <- length(modules)
  
  # formating and splitting
  for (i in 1:number)  {
  modules[i] <- gsub('\t', ',', modules[i])
  }
  
  modules <- strsplit(modules, split=",")
  
  result <- list()
  
  for (i in 1:number){
    genes <- modules[[i]][-c(1)]
    lable <- modules[[i]][1]
    result[[lable]] <- genes
  }
  
  return(result)
}

modules2DF <- function(modules){
  modules_df <- data.frame(
    GSE = modules %>% names %>% str_extract(. ,"(.*?)_") %>% gsub("_", "", .),
    GPL = modules %>% names %>% str_extract(. ,"_(.*?)#") %>% gsub("_", "", .) %>% gsub("#", "", .),
    moduleSize = modules %>% lapply(length) %>% unlist %>% unname(),
    moduleNumber = modules %>% names %>% str_extract("#\\d+") %>% gsub("#", "", .))
  
  return(modules_df)
}

modules2GSE_df <- function(modules_df, hp_df, cp_df){
  df <- modules_df %>% filter(moduleNumber!=0)
  result <- df %>% plyr::count(c("GSE", "GPL"))
  colnames(result)[3] <- "numberOfModules"
  result <- aggregate(.~GSE+GPL, df, mean) %>% select(-c(moduleNumber)) %>% merge(result)
  colnames(result)[3] <- "meanModuleSize"
  result <- aggregate(.~GSE+GPL, df, median) %>% select(-c(moduleNumber)) %>% merge(result)
  colnames(result)[3] <- "medianModuleSize"
  result <- aggregate(.~GSE+GPL, df, max) %>% select(-c(moduleNumber)) %>% merge(result)
  colnames(result)[3] <- "maxModuleSize"
  result <- modules_df %>% filter(moduleNumber==0) %>% select(-c(moduleNumber)) %>% merge(result)
  colnames(result)[3] <- "zerothModuleSize"
  result <- hp_df %>% plyr::count(c("GSE", "GPL")) %>% merge(., result, by=c("GSE", "GPL"), all.y = T)
  colnames(result)[3] <- "halmarkOverrep"
  result <- cp_df %>% plyr::count(c("GSE", "GPL")) %>% merge(., result, by=c("GSE", "GPL"), all.y = T)
  colnames(result)[3] <- "cannonicalOverrep"
  result[is.na(result$halmarkOverrep),]["halmarkOverrep"] <- 0
  result[is.na(result$cannonicalOverrep),]["cannonicalOverrep"] <- 0
  return(result)
}

hp_df <- readRDS(paste(c(dataPath, "/hp_df.rds"), collapse=""))

cp_df <- readRDS(paste(c(dataPath, "/cp_df.rds"), collapse=""))

modules_list <- readModules(modulesPath)
saveRDS(modules_list, paste(c(dataPath, "/modules_list.rds"), collapse=""))

modules_df <- modules_list %>% modules2DF
saveRDS(modules_df, paste(c(dataPath, "/modules_df.rds"), collapse=""))

gse_df <- modules2GSE_df(modules_df, hp_df, cp_df)

saveRDS(gse_df, paste(c(dataPath, "/gse_df.rds"), collapse=""))


