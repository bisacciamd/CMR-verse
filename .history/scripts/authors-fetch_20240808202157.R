source("R/fetch_first_author.R")
source("R/fetch_first_authors_list.R")
source("R/fetch-journal-abbrv.R")

# filter papers to only include Q1, CMR relevant journals
papers_cmr <- papers |> filter(SO %in% toupper(journals_all$`Source title`))

# determine first authors
first_authors_cmr_list <- fetch_first_authors_list(papers = papers_cmr)
first_authors_cmr_unique <- unique(first_authors_cmr_list)

# determine last authors
last_authors_cmr_list <- as.character(sapply(papers_cmr$AF, function(x) {
  authors <- strsplit(x, split = ";")[[1]]
  authors[length(authors)]
}))
last_authors_cmr_unique <- unique(last_authors_cmr_list)

# join first and last authors lists
all_cmr_authors_list <- c(first_authors_cmr_list, last_authors_cmr_list)

# Create a frequency table
authorship_freq_table <- table(all_cmr_authors_list)

# Extract authors that occur more than once
prolific_cmr_authors_indices <- names(authorship_freq_table[authorship_freq_table > 1])

# Find prolific authors
prolific_cmr_authors <- all_cmr_authors_list[all_cmr_authors_list %in% prolific_cmr_authors_indices] |> unique()

writexl::write_xlsx(as.data.frame(last_authors_cmr_list), path = paste0("data/last-authors-list_", Sys.Date(), ".xlsx"))
