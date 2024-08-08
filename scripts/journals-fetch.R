source("R/fetch-journal-abbrv.R")

# select only card and rad journals
journals_all$Category <- sapply(strsplit(journals_all$`Highest percentile`, split = "\n"), `[`, 3)
journals_all <- journals_all |> filter(Category== "Radiology, Nuclear Medicine and Imaging" | Category == "Cardiology and Cardiovascular Medicine")
journals_card <- journals_all |> filter(Category == "Cardiology and Cardiovascular Medicine")
journals_rad <- journals_all |> filter(Category == "Radiology, Nuclear Medicine and Imaging")

# fetch abbreviated titles from Endnote list
journal_abbrv$`Source title` <- journal_abbrv$V1
journals_all <- merge(journals_all, journal_abbrv, by = "Source title", all.x = TRUE)

# select only Q1 journals with publications relevant to CMR as captured on pubmed
# NB as of now, this removes non-english journals because shortened names excluded "Engl ed."
journals_all_CMR <- journals_all |> filter(toupper(`Source title`) %in% unique(papers$SO))
