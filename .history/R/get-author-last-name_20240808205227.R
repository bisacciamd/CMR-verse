get_author_last_name <- function(author) {
  # Split the string by the comma
  parts <- strsplit(author, ",")[[1]]
  # Extract the first part and trim whitespace
  last_name <- trimws(parts[1])
  return(last_name)
}
