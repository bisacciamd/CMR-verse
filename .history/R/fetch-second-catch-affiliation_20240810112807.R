library(stringr)

remaining_authors <- read.csv("data/remaining-authors.csv")
remaining_authors$lastname <- word(remaining_authors$author,-1)
remaining_authors$firstname <- as.character(strsplit(remaining_authors$author, split = paste0(" ", remaining_authors$lastname)))

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
total <- nrow(remaining_authors)

# Looks for current affiliation on Scopus or leaves it empty if absent
for (i in seq_len(total)) {
  query <- paste0("authlast(", remaining_authors$lastname[i], ") and authfirst(", remaining_authors$firstname[i], ")")
  
  # API call
  result <- tryCatch({
    generic_elsevier_api(query = query, type = "search", search_type = "author", headers = hdr)$content$`search-results`$entry
  }, error = function(e) {
    NULL  # In case of an error, return NULL
  })
  
  if (length(result) > 0 && !is.null(result[[1]]$`affiliation-current`$`affiliation-name`)) {
    # Extract and assign affiliation details
    affiliation_details <- extract_affiliation_details(result[[1]])
    remaining_authors$affiliation[i] <- affiliation_details$affiliation
    remaining_authors$affil_city[i] <- affiliation_details$city
    remaining_authors$affil_country[i] <- affiliation_details$country
  } else {
    # Set to NA if no result or missing affiliation details
    remaining_authors$affiliation[i] <- NA
    remaining_authors$affil_city[i] <- NA
    remaining_authors$affil_country[i] <- NA
  }
  
  # Calculate and print the percentage of completion
  percent_complete <- (i / total) * 100
  message(sprintf("Processing: %.2f%% complete", percent_complete))
}

write.csv(remaining_authors, "data/remaining-authors.csv")

table <- read.xlsx("data/table-last-authors.xlsx")

# Perform the left join to merge the information
merged_table <- merge(table, remaining_authors, by.x = "fullname", by.y = "author", all.x = TRUE, suffixes = c("", "_new"))

# Replace missing values in the original columns with values from the merged columns
merged_table$affiliation <- ifelse(is.na(merged_table$affiliation), merged_table$affiliation_new, merged_table$affiliation)
merged_table$affil_city <- ifelse(is.na(merged_table$affil_city), merged_table$affil_city_new, merged_table$affil_city)
merged_table$affil_country <- ifelse(is.na(merged_table$affil_country), merged_table$affil_country_new, merged_table$affil_country)

# Drop the newly joined columns as they are no longer needed
merged_table <- merged_table[, !colnames(merged_table) %in% c("affiliation_new", "affil_city_new", "affil_country_new")]

# Now merged_table is your original table with the missing values filled
merged_table$lastname <- NULL
merged_table$firstname <- NULL

writexl::write_xlsx(merged_table, "data/table-last-authors.xlsx")
