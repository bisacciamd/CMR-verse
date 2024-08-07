fetch_first_authors_list <- function(papers) {
  first_authors <- c()
  for (i in 1:nrow(papers)) {
    first_authors[i] <- fetch_first_author(papers, i)
  }
  return(first_authors)
}