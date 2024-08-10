#install.packages("tidygeocoder")
library(tidygeocoder)

get_lat_lon_tidygeocoder <- function(city, country) {
  location_data <- data.frame(city = city, country = country, stringsAsFactors = FALSE)
  location_data$address <- paste(location_data$city, location_data$country, sep = ", ")
  
  result <- geocode(location_data, address = address, method = 'osm')
  
  return(c(latitude = result$lat, longitude = result$long))
}

# Step 1: Identify Unique City-Country Pairs
unique_locations <- unique(last_authors_cmr[, c("affil_city", "affil_country")])

# Step 2: Geocode Unique Pairs
coords_unique <- t(sapply(1:nrow(unique_locations), function(i) {
  
  # Calculate the percentage completion
  percent_complete <- round((i / nrow(unique_locations)) * 100, 2)
  
  # Print the percentage completion
  print(paste("Processing unique row", i, "of", nrow(unique_locations), "(", percent_complete, "% complete)"))
  
  # Call the geocoding function
  get_lat_lon_tidygeocoder(
    city = unique_locations$affil_city[i],
    country = unique_locations$affil_country[i]
  )
}))

# Step 3: Convert results to data frame and merge with unique_locations
coords_unique_df <- as.data.frame(coords_unique)
unique_locations <- cbind(unique_locations, coords_unique_df)

# Step 4: Map results back to the original last_authors_cmr dataframe
last_authors_cmr <- merge(last_authors_cmr, unique_locations, by = c("affil_city", "affil_country"), all.x = TRUE)

# The last_authors_cmr dataframe now contains latitude and longitude columns


# Convert the result to a data frame and add it to the last_authors dataframe
coords_df <- as.data.frame(coords)
last_authors_cmr$latitude <- coords_df$lat
last_authors_cmr$longitude <- coords_df$long

writexl::write_xlsx(last_authors_cmr, "data/table-last-authors-location.xlsx")
