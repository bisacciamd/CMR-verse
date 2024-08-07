library(rentrez)
library(dplyr)

# Simple version
journal_info <- function (top_journal) {
  search_term <- paste(top_journal, "[TA]")
  journal_query <- entrez_search(db="pubmed", term=search_term)
  id <- journal_query$ids[1]
  summary_result <- entrez_summary(db = "pubmed", id = id)
  issn <- summary_result$issn
  title <- summary_result$fulljournalname
  j_info <- c(title) #data.frame(issn,title)
  j_info
}

# Batch version
journal_info_batch <- function(top_journals, api_key = NULL) {
  results <- data.frame(issn = character(), title = character(), stringsAsFactors = FALSE)
  
  for (journal in top_journals) {
    search_term <- paste(journal, "[TA]", sep = "")
    journal_query <- entrez_search(db = "pubmed", term = search_term, api_key = api_key)
    
    if (length(journal_query$ids) > 0) {
      id <- journal_query$ids[1]
      summary_result <- entrez_summary(db = "pubmed", id = id, api_key = api_key)
      issn <- summary_result$issn
      title <- summary_result$fulljournalname
      results <- rbind(results, data.frame(issn, title, stringsAsFactors = FALSE))
    } else {
      results <- rbind(results, data.frame(issn = NA, title = NA, stringsAsFactors = FALSE))
    }
    
    # Delay to avoid hitting rate limit
    Sys.sleep(0.01)
  }
  
  return(results)
}
