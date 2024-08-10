#install.packages("rscopus")
library(rscopus)
set_api_key(readLines("data/scopus_api_key.secret"))
token <- readLines("data/scopus_token.secret")

# retrieve my publications
hdr <- auth_token_header(token)
#hdr <- auth_token_header(token)
res <- author_df(last_name = "Bisaccia", first_name = "Giandomenico", verbose = FALSE, headers = hdr)

# retrieve an affiliation
x <- affiliation_retrieval("60006183", identifier = "affiliation_id", headers = hdr,
   verbose = T)