#install.packages("rscopus")
library(rscopus)
set_api_key("88fa9a2e059c1d529bb90cc0d4719bed")
token <- readLines("data/scopus_token.secret")

# token is from Scopus dev
hdr <- inst_token_header(token)
res <- author_df(last_name = "Bisaccia", first_name = "Giandomenico", verbose = FALSE, general = FALSE, headers = hdr)
