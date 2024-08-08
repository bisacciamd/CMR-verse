library(readxl)
library(dplyr)
library(bib2df)
library(bibliometrix)

# card / rad journals derived from scimagojr
#journals_card <- read_xlsx("data/raw/journals-cardiology.xlsx")
#journals_rad <- read_xlsx("data/raw/journals-radiology.xlsx")

# top 10% journals derived from scopus
journals_all <- read_xlsx("data/scopus.xlsx")

# to add testthat implementation to check whether binding leads to data loss?
# library(testthat)

# load papers from pubmed
#source("R/pubmed-data-fetch.R")

papers <- readRDS(list.files("data/", pattern = "\\.RDS$", full.names = TRUE) %>% 
  file.info() %>% {rownames(.)[which.max(.$mtime)]})

papers_n <- length(papers$AU)

#results <- biblioAnalysis(papers)
saveRDS(results, paste0("data/pubmed-results_", Sys.Date(),".RDS")
# get insights about these data:
#summary(results)

# fetch journals with abbreviations
source("scripts/journals-fetch.R")
