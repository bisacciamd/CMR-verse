query <- paste0("authlast(FONTANA) and authfirst(MARIANNA)")

generic_elsevier_api(query = query, type = "search", search_type = "author", headers = hdr)$content$`search-results`$entry
