#install.packages("devtools")
#install.packages("bibliometrix")
#devtools::install_github("massimoaria/pubmedR")
library(pubmedR)
library(bibliometrix)

api_key <- readLines("data/pubmed-api.secret")
query <- "(Magnetic Resonance Imaging, Cine[Mesh] OR (Magnetic Resonance Angiography[Mesh] AND Heart [Mesh]) AND 2019[PDAT] : 2024[PDAT]"
# alt query including "diagnostic imaging" > query <- "(Diagnostic Imaging[Mesh] AND Heart[Mesh]) OR Magnetic Resonance Imaging, Cine[Mesh] OR (Magnetic Resonance Angiography[Mesh] AND Heart [Mesh]) AND 2019[PDAT] : 2024[PDAT]"

res <- pmQueryTotalCount(query = query, api_key = api_key)

D <- pmApiRequest(query = query, limit = res$total_count, api_key = NULL)

papers <- convert2df(D, dbsource = "pubmed", format = "api")

# add full titles in new column: BEWARE - time-consuming
# papers$JI_full <- sapply(unique(papers$JI), journal_info)

saveRDS(papers, file = paste0("data/pubmed-export_", Sys.Date(), ".RDS"))
