args <- commandArgs(TRUE)

pathIn <- as.character(args[1]) 
pathOut <- as.character(args[2])

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

modules <- readModules(pathIn)

saveRDS(modules, pathOut)