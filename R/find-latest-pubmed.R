# List all RDS files in the directory
rds_files <- list.files("data/pubmed-export", pattern = "\\.RDS$", full.names = TRUE)

# Get information about these files
file_info <- file.info(rds_files)

# Identify the most recently modified file
latest_file <- rownames(file_info)[which.max(file_info$mtime)]

# Read the RDS file
papers_doublecheck <- readRDS(latest_file)
