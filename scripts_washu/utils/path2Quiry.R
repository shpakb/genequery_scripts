################################ARGS##############################
args <- commandArgs(TRUE)

pathIn <- as.character(args[1]) 
pathOut <- as.character(args[2])
q1 <- as.character(args[3])
q2 <- as.character(args[4])
quiry <- c(q1, q2)

################################FUNCS##############################
library(tidyverse)

readSets<- function(file){
  pathways <- readLines(file)
  number <- length(pathways)
  
  #formating and splitting
  for (i in 1:number)  {
    pathways[i] <- gsub('\t', ',', pathways[i])
  }
  pathways <- strsplit(pathways, split=",")
  
  #getting pathways content
  names <- c()
  genes <- list()

  for (i in 1:number){
    names <- c(names, pathways[[i]][1])
    genes[[i]] <- pathways[[i]][-c(1,2)]
  }
  
  return(list(genes = genes,
              names = names,
              number = number))
}

################################FUNCS##############################

sets <- readSets(pathIn)

text <- quiry

for (i in 1:sets$number){
  text <- c(quiry, sets$genes[[i]]) %>% paste(., collapse = "\n") 
  write(text, gsub(" ", "", paste(pathOut, sets$names[i])), sep = "")
  test <- quiry 
}
