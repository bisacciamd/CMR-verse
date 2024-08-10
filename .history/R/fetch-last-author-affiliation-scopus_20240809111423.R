source("R/scopus-tidy.R")

# looks for current affiliation on scopus or leaves it empty if absent
for (i in 1:nrow(last_authors_cmr)) {
   result <- generic_elsevier_api(
     query = paste0("authlast(", last_authors_cmr$lastname[i], ") and authfirst(", last_authors_cmr$firstname[i], ")"),
     type = "search", 
     search_type = "author", 
     headers = hdr
   )$content$`search-results`$entry
   
   if (length(result) > 0 && !is.null(result[[1]]$`affiliation-current`$`affiliation-name`)) {
     last_authors_cmr$affiliation[i] <- result[[1]]$`affiliation-current`$`affiliation-name`
     last_authors_cmr$affil_city[i] <- result[[1]]$`affiliation-current`$`affiliation-city`
     last_authors_cmr$affil_country[i] <- result[[1]]$`affiliation-current`$`affiliation-country`
   } else {
     last_authors_cmr$affiliation[i] <- NA  # or "" for an empty string
   }
 }
 