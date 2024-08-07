#install.packages("rscopus")
library(rscopus)
set_api_key("88fa9a2e059c1d529bb90cc0d4719bed")
?rscopus::affiliation_retrieval()

affiliation_retrieval("60006183", identifier = c("affiliation_id", "eid"),
  http_end = NULL)
