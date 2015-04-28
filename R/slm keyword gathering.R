library(plyr)
library(dplyr)
library(gdata)
library(reshape2)
library(magrittr)
library(xlsx)

# Read in the dhq_master_lut
master.lut <- read.xlsx("./data/masters/dhq_master_author_lut.xlsx",1, stringsAsFactors = FALSE)

names(mater.lut) %>% 
  tolower()

# Read in the sterling_master
sterling.master <- read.xlsx("./data/masters/dhq_sterling_master.xlsx",1, stringsAsFactors = FALSE)

names(sterling.master) %<>%
  tolower()

temp.master <- sterling.master[,c("article.id","authors","dhq.keywords")] 

temp.lut <- join(master.lut,temp.master[,c(-2)],by="article.id",type="left")

m.keyword <- melt(temp.lut,c("article.id","author"),c("dhq.keywords")) 


#Build an keyword aggregator function
keyword.aggregate <- function(x){
  filter(m.keyword,author==x) %>% 
    select(matches("dhq.keywords")) %>%
    unlist() %>% 
    paste0(.,collapse = " | ")
}

# Aggregate the keywords for each record in the LUT
keyword.list <- m.keyword$author %>% 
  lapply(.,keyword.aggregate) %>% 
  unlist

# Add that column to the LUT
master.lut$aggregated.dhq.keywords <- keyword.list






