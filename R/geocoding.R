library(readr)
library(tidyr)
library(stringr)
library(plyr)
library(dplyr)
library(gdata)
library(reshape2)
library(magrittr)
library(rvest)
library(ggmap)

#read in the master_author_lut
author.lut <-read.xlsx("data/author_lut.xlsx",1, stringsAsFactors = FALSE)


# Create a list of institutional affiliations and geocode them
unique.affiliation <- author.lut$affiliation %>% 
  trim %>% 
  unique() %>% 
  na.omit() %>% 
  as.character

geo.unique.affiliation <- geocode(unique.affiliation, output = "more", messaging = FALSE) %>%
  cbind(unique.affiliation,.)


# Provide more LOD for Companies, Non-profits etc  
geo.missing <- geo.unique.affiliation[is.na(geo.unique.affiliation$lon)==TRUE,] 

geo.missing$unique.affiliation %<>%
  as.character()

geo.missing <- geo.missing[,1]

geo.missing.lod <- c("Amsterdam",
                     "Amsterdam",
                     "Maryland",
                     "New York",
                     "San Francisco")
  

geo.completed <- geocode(paste0(geo.missing,",",geo.missing.lod), output="more", messaging = FALSE) %>% 
  cbind(geo.missing,.)

names(geo.completed) <- names(geo.unique.affiliation)

geo.unique.affiliation <- rbind(geo.unique.affiliation,geo.completed)

# This data file was exported and manually fixed in excel.
write.csv(geo.unique.affiliation,"geocoded_affiliations.csv")

# Merge the master author LUT with the geocoded information
geocoded.unique.affiliation <- read.csv("data/fixxed_geocoded_affiliations.csv")

geo.master.lut <- join(author.lut,geocoded.unique.affiliation,by="affiliation",type="left")

write.xlsx(geo.master.lut,"data/master/dhq_master_author_lut.xlsx")

