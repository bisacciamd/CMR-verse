query <- "authlast(fontana) and authfirst(marianna) and auth-subclus(medi)"

r <-  generic_elsevier_api(query = query, type = "search", search_type = "author", heade = hdr)$content$`search-results`$entry
