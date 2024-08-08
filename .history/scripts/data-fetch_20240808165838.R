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
papers <- readRDS("data/pubmed-export_2024-08-08.RDS")

#papers <- readRDS(list.files("data/pubmed-export", pattern = "\\.RDS$", full.names = TRUE) %>% 
#  file.info() %>% {rownames(.)[which.max(.$mtime)]})

papers_n <- papers$Articles

results <- biblioAnalysis(papers)
#saveRDS(results, paste0("data/pubmed-results_", Sys.Date(),".RDS"))

results <- readRDS("data/pubmed-results_2024-08-08.RDS")
# get insights about these data:
#summary(results)

# fetch journals with abbreviations
source("scripts/journals-fetch.R")

str(papers)
