fetch_first_author <- function(papers, i) {
  first_author <- strsplit(papers$AF, split=";")[[i]][1]
  return(first_author)
}