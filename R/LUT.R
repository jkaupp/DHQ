library(stringr)
library(plyr)
library(dplyr)
library(gdata)
library(reshape2)
library(magrittr)
library(rvest)
library(xlsx)

# Load a group members most up to date clean dataset with some missing files added.
dhq.master <- read.delim("./data/dhq articles/dhq_articles.tsv",
                         header = TRUE,
                         sep = "\t",
                         stringsAsFactors = FALSE)

dhq.web <- list.files("data/dhq articles/dhq_source_tsv", full.names = TRUE) %>% 
  lapply(.,read.delim, sep= "\t", header=FALSE, stringsAsFactors=FALSE) %>% 
  data.table::rbindlist() %>% 
  data.table::setnames(.,tolower(c("Article.ID",
                                   "Authors",
                                   "Publication.Year",
                                   "Title",
                                   "Abstract",
                                   "Journal.Conference.Citation",
                                   "Cited References",
                                   "isDHQ",
                                   "drop"))) %>% 
  as.data.frame 

# This command identifies which files are missing from the client provided dataset
dhq.web <- dhq.web[,c(-9)]
missing.files <- dhq.web[!dhq.web$article.id %in% dhq.master$article.id,]

# Gather information for the author look-up table
# Scrape information from the DHQ title website, as it groups authors with articles and institutions more readily
# The following formats it into a data frame, the records are NOT UNIQUE, and have replicates

author.affil <- html("http://www.digitalhumanities.org/dhq/index/title.html") %>% 
  html_nodes('#titleIndex .authors') %>% 
  html_text()  %>% 
  strsplit('[;]') %>%
  trim() %>% 
  unlist() %>% 
  colsplit(", ",c("author","affiliation")) %>% 
  trim() %>% 
  filter(author!="Marion Thain") %>% 
  filter(author!="Deena Engel") %>% 
  filter(author!="Katina Rogers") 

author.affil[author.affil$author=="Dennis G. Jerz",1] <- "Dennis Jerz"
author.affil[author.affil$author=="Matthew G. Kirschenbaum",1] <- "Matthew Kirschenbaum"
author.affil[author.affil$author=="J.J. Butts",1] <- "Jimmy Butts"
author.affil[author.affil$author=="Melissa Terras",1] <- "Melissa M. Terras"
author.affil[author.affil$author=="Frédéric Clavert",1] <- "Frederic Clavert"
author.affil[author.affil$author=="William A. Kretzschmar",2] <- "University of Georgia"
  
dhq.authors <- dhq.web$authors %>% 
  strsplit('[|]') %>% 
  unlist %>% 
  trim

dhq.authors %<>%
  str_replace_all("Jerz, Dennis G.","Jerz, Dennis") 
dhq.authors %<>%
  str_replace_all("Kirschenbaum, Matthew G.", "Kirschenbaum, Matthew") 
dhq.authors %<>%
  str_replace_all("Butts, J.J.", "Butts, Jimmy") 
dhq.authors %<>%
  str_replace_all("Terras, Melissa", "Terras, Melissa M.")
dhq.authors %<>%
  str_replace_all("Terras, Melissa M. M.", "Terras, Melissa M.")
dhq.authors %<>%
  str_replace_all("Kretzschmar, Jr., William A.","Kretzschmar, William A.")

dhq.unique.authors <- dhq.authors %>% 
  unique 

dhq.unique.authors <- dhq.unique.authors %>% 
  colsplit(",",c("lastname","firstname")) %>% 
  trim()

dhq.unique.authors$author <- paste(dhq.unique.authors$firstname, dhq.unique.authors$lastname, sep = " ")
  
author.affil %<>%
  join(dhq.unique.authors,by="author",type="full")

author.affil <- author.affil[, c("author","firstname","lastname","affiliation")]

author.affil[author.affil$author=="Elisabet Takehana",4] <- "Fitchburg State University"
author.affil[author.affil$author=="Mauro Carassai",4] <- "University of Florida"

# Redo name into dhq format
author.affil$author <- paste(author.affil$lastname,author.affil$firstname,sep = ", ") 

# Art.id.list is the list of article ids from the DHQ website
# Author list produces a list of authors for each article
n.authors <- dhq.web$authors %>% 
  strsplit('[|]') %>% 
  lapply(length)

article.id.replist <- rep(art.id.list,n.authors)

author.affil %<>% 
  arrange(author)

# Output the iterim author look-up table
author.lut <- data.frame(article.id.replist,dhq.authors) %>% 
  set_names(c("article.id","author")) %>% 
  arrange(author) %>% 
  data.frame(.,author.affil[,c(2:4)]) %>% 
  join(dhq.web[,c(1,3)],by="article.id",type="left") %>% 
  set_names(c("article.id","author","firstname","lastname","affiliation","year"))

# Write it to a file
write.xlsx(author.lut,"data/author_lut.xlsx")

# The basic author lut was joined with updated_dhq_articles_2007_2014.csv 
# provided by a teammate, which contained extra columns cite.me.as and fixed years.
# there were added via a join

# Read in the csv
dhq_articles_2007_2014 <- read.csv("data/masters/updated_dhq_articles_2007_2014.csv",stringsAsFactors = FALSE)

names(dhq_articles_2007_2014) %<>%
  tolower()
  
author.lut <- dhq_articles_2007_2014 %>% 
  select(article.id,publication.year,cite.me.as) %>% 
  join(author.lut,.,by="article.id",type="left")

author.lut <- author.lut[,-6] %>% 
  write.xlsx("data/author_lut.xlsx")


