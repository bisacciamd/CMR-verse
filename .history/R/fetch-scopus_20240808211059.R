source("R/scopus-tidy.R")

# retrieve my publications
#hdr <- auth_token_header(token)
res <- author_df(last_name = "Bisaccia", first_name = "Giandomenico", verbose = FALSE, headers = hdr)

# retrieve an affiliation
x <- affiliation_retrieval("60006183", identifier = "affiliation_id", headers = hdr,
   verbose = T)