source("R/scopus-tidy.R")

# retrieve my publications
hdr <- auth_token_header(token)
if (have_api_key()) {
   res = author_df(last_name = "Muschelli", first_name = "John", api_key = api_scopus, headers = hdr,
   verbose = FALSE)
   }

   res = get_complete_author_info(last_name = "Smith", first_name = "Richard", headers = hdr)


res <- author_df(verbose = T, last_name = "Bisaccia", first_name = "Giandomenico", api_key = api_scopus, headers = hdr)

# retrieve an affiliation
x <- affiliation_retrieval("60006183", identifier = "affiliation_id", headers = hdr,
   verbose = T)