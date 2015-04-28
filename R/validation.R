library(xlsx)
library(tidyr)
library(stringr)
library(dplyr)
library(gdata)
library(reshape2)
library(magrittr)
library(data.table)

sterling.master <- read.xlsx("./data/masters/dhq_sterling_master.xlsx",1, stringsAsFactors = FALSE)
master.lut <- read.xlsx("./data/masters/dhq_master_author_lut.xlsx",1, stringsAsFactors = FALSE)

names(sterling.master) %<>%
  tolower()

# Determine number of unique countries
sterling.master$country %>% 
  strsplit('[|]') %>% 
  unlist %>% 
  strsplit(" and ") %>% 
  unlist %>% 
  na.omit %>% 
  trim %>% 
  unique %>% 
  write.csv("dhq_unique_countries.csv")

sterling.master$authors %>% 
  strsplit('[|]') %>% 
  unlist %>% 
  trim %>% 
  unique %>% 
  write.csv("dhq_unique_authors.csv")

sterling.master$affiliation %>% 
  strsplit('[|]') %>% 
  unlist %>% 
  trim %>%
  strsplit(' and ') %>% 
  unlist %>% 
  trim %>% 
  unique %>% 
  write.xlsx("dhq_unique_affiliations.xlsx")

master.lut$WOS.Subject.Area %>% 
  unique
  