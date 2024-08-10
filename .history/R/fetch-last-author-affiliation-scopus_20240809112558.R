source("R/scopus-tidy.R")

# Function to extract affiliation details from the API result
extract_affiliation_details <- function(result_entry) {
  list(
    affiliation = ifelse(!is.null(result_entry$`affiliation-current`$`affiliation-name`), 
                         result_entry$`affiliation-current`$`affiliation-name`, NA),
    city = ifelse(!is.null(result_entry$`affiliation-current`$`affiliation-city`), 
                  result_entry$`affiliation-current`$`affiliation-city`, NA),
    country = ifelse(!is.null(result_entry$`affiliation-current`$`affiliation-country`), 
                     result_entry$`affiliation-current`$`affiliation-country`, NA)
  )
}

# Total number of iterations
total <- nrow(last_authors_cmr)

# Looks for current affiliation on Scopus or leaves it empty if absent
for (i in seq_len(total)) {
  query <- paste0("authlast(", last_authors_cmr$lastname[i], ") and authfirst(", last_authors_cmr$firstname[i], ")")
  
  # API call
  result <- tryCatch({
    generic_elsevier_api(query = query, type = "search", search_type = "author", headers = hdr)$content$`search-results`$entry
  }, error = function(e) {
    NULL  # In case of an error, return NULL
  })
  
  if (length(result) > 0 && !is.null(result[[1]]$`affiliation-current`$`affiliation-name`)) {
    # Extract and assign affiliation details
    affiliation_details <- extract_affiliation_details(result[[1]])
    last_authors_cmr$affiliation[i] <- affiliation_details$affiliation
    last_authors_cmr$affil_city[i] <- affiliation_details$city
    last_authors_cmr$affil_country[i] <- affiliation_details$country
  } else {
    # Set to NA if no result or missing affiliation details
    last_authors_cmr$affiliation[i] <- NA
    last_authors_cmr$affil_city[i] <- NA
    last_authors_cmr$affil_country[i] <- NA
  }
  
  # Calculate and print the percentage of completion
  percent_complete <- (i / total) * 100
  message(sprintf("Processing: %.2f%% complete", percent_complete))
}
