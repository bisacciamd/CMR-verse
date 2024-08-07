library(readxl)
library(dplyr)
library(bib2df)
library(bibliometrix)

# card / rad journals derived from scimagojr
journals_card <- read_xlsx("data/raw/journals-cardiology.xlsx")
journals_rad <- read_xlsx("data/raw/journals-radiology.xlsx")

# top 10% journals derived from scopus
journals_all <- read_xlsx("data/scopus.xlsx")

# to add testthat implementation to check whether binding leads to data loss?
# library(testthat)

# papers <- bib2df("data/raw/pubmed-2019-2024.bib")
# saveRDS(papers, "data/pubmed.RDS")

papers <- readRDS("data/pubmed-export_2024-08-07.RDS")
papers_n <- length(papers$AU)

results <- biblioAnalysis(papers)

# get insights about these data:
#summary(results)

# fetch journals with abbreviations
source("scripts/journals-fetch.R")