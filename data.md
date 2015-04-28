Data files for DHQ Bibliography Project
=======================================

##Culture Mapping

1. **BiblioBackBoneSLM.csv**

  The results from the backbone identification algorithm from the SLM community results using sci2. This extraction was conducted on the dhq_sterling_master file.

2. **slm communities v2.xlsx**

  The results from the SLM community detection algorithm from the extracted co-author network using sci2.  This was conducted on the dhq_sterline_master file.

3. **wos-department mapping.csv**

  The manual mapping of Web of Science Subject Area keywords, scraped from the web, to department affiliation of authors.


## DHQ Provided Data

1. **dhq_articles.tsv**

  This table includes a row for each DHQ article.  This was generated from the xml files provided by the client, and supplemented with those scraped from the web.

2. **dhq_article_source_xml**

  This folder contains the XML data for each article in DHQ. This is the data from which the tab-delimited dhq_articles.tsv (above) was derived. The XML also contains the full-text of the article.

3. **works_cited_in_dhq.tsv**

  This table includes a row for each work that is cited by DHQ articles. Each table has the following columns:

  * article id [Biblio ID in works_cited_in_dhq.tsv; DHQ ID in dhq_articles.tsv]
  * author
  * year
  * title
  * journal/conference/collection [title of journal, conference, or monograph in which the work appears]
  * abstract [only populated in dhq_articles.tsv]
  * reference IDs [IDs of all the works cited by an individual DHQ article; only relevant and populated in dhq_articles.tsv]
  * isDHQ [Boolean: 1/true means it's a DHQ article; 0/false means it is not; populated in both tables but redundant in dhq_articles.tsv, since these are all DHQ articles]
<br><br>
4. **works_cited_in_dhq.xml**

  This is XML data from which the tab-delimited works_cited_in_dhq.tsv (above) was derived.

5. **xslt**

  This folder contains the xml style transformations to generate the dhq_articles and works_cited_in_dhq tab separated variables.

  * **articles-to-cni.xsl**

    An XSLT stylesheet that creates a tab-delimited record from a single article source file. The individual records are then concatenated to create, for example, dhq_articles.tsv.

  * **biblio-to-cni.xsl**

    An XSLT stylesheet that creates tab-delimited records (e.g., works_cited_in_dhq.tsv)  from the works_cited_in_dhq.xml source file.

## Master Files

1. **updated_dhq_articles_2007_2014.csv**

  This file was produced which added Country, Affiliation, CiteMeAs, TimesCited, Cited References, and Count Cited References fields.

2. **dhq_sterling_master.xlsx**

  This is the master file for all visualizations.  Using the updated_dhq_articles file it adds disciplinary affiliation, wos_subject_area, latitude, longitude, geocoded country, DHQ_keywords and slm_backbone_commmunity detection.

3. **dhq_master_author_lut.xslx**

  This is the author look up table which provides each author and co-author of each paper separately. It includes nearly all the same information as does the sterling_master.  It's utility is to classify authors by geospatial, affiliation or disciplinary lines.
