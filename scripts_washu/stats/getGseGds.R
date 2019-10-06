library(tidyverse)

gse_gds <- list.files("/home/shpakb/gq/gq_queries/hs/diffexp")  %>% str_match("(.*?)_GPL") %>% .[,2]
