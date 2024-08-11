library(readxl)
library(dplyr)
library(bib2df)
library(bibliometrix)
library(rscopus)

# top 10% journals derived from scopus
journals_all <- read_xlsx("data/scopus.xlsx")

# load papers from pubmed
#source("R/pubmed-data-fetch.R")
papers <- readRDS("data/pubmed-export_2024-08-08.RDS")
source("scripts/journals-fetch.R")

papers_n <- papers$Articles
papers_ <- papers |> filter(SO %in% toupper(journals_all_CMR$`Source title`))

#results <- biblioAnalysis(papers_, sep = ";")
#saveRDS(results, paste0("data/pubmed-results_", Sys.Date(),".RDS"))

results <- readRDS("data/pubmed-results_2024-08-08.RDS")
# get insights about these data:
S <- summary(object = results, k = 10, pause = FALSE)
#plot(x = results, pause = T) # not working

threeFieldsPlot(papers_)
# fetch journals with abbreviations
