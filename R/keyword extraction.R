library(stringr)
library(plyr)
library(magrittr)
library(xlsx)
library(rvest)


# Using the LUT.R output, department was populated through manual web searches for each author.

# Keywords were pre-concatenated in excel.
# Read in modified keywords file
keyword.list.raw <- read.xlsx("data/dhq_keywords.xlsx",1, stringsAsFactors=FALSE)

# Get rid of extra pipes
keyword.list.raw[,21] %<>% 
  str_replace("([ ][|][ ]){2,14}", "")

# get WOS Subject area category
wos.subject.category <- html("http://images.webofknowledge.com/WOKRS57B4/help/WOS/hp_subject_category_terms_tasca.html") %>% 
  html_nodes('.col1 .content p') %>% 
  html_text()  %>% 
  write.csv("data/culture mapping/wos_subject_cateogy.csv")

# This csv was taken, and each department was manually mapped to a wos subject category
# these were guided by wos scope documents (http://ip-science.thomsonreuters.com/mjl/scope/scope_ahci/)
wos.dept.mapping<-read.csv("data/culture mapping/wos-department mapping.csv", stringsAsFactors = FALSE) 


author.lut <- read.xlsx("data/author_lut.xlsx",1, stringsAsFactors = FALSE)

# Join WOS Subject Area Classiciation/Discipline and write it out
author.lut %<>% 
  join(.,wos.dept.mapping,by="department",type="left") %>% 
  write.xlsx("data/author_lut.xlsx")

# Join the DHQ keywords to the master and write it out
authour.lut %<>% 
  join(.,keyword.list.raw[,c(2,21)],by="article.id",type="left") %>% 
  write.xlsx("data/author_lut.xlsx")





