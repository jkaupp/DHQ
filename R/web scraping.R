library(magrittr)
library(rvest)
library(stringr)

# Pull all data from all DHQ issues

article.list <-html("http://www.digitalhumanities.org/dhq/") %>% 
  html_nodes("#leftsidenav ul:nth-child(2) a , ul:nth-child(6) a") 

# Build a web-scraping function
scrape <- . %>%
  html(.) %>% 
  html_nodes("p a") %>%
  html_attr("href")

article.url <- article.list %>% 
  html_attr("href") %>% 
  paste0("http://www.digitalhumanities.org",.) %>% 
  lapply(scrape) %>% 
  unlist %>% 
  gsub("html", "xml",.) %>% 
  paste0("http://www.digitalhumanities.org",.)
  
# Use mapply and download file to read all XML data into a directory.  
mapply(download.file,article.url,paste0("data/dhq articles/dhq_source_xml/",basename(article.url))) 
  
# Outisde of R, using Saxon apply the xslt transformation to turn the xml into properly formatted tsv
  

