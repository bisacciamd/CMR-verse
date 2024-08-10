get_author_first_name <- function(author) {
  # Split the string by the comma
  parts <- strsplit(author, ",")[[1]]
  # Extract the second part and trim whitespace
  first_name <- trimws(parts[2])
  return(first_name)
}
