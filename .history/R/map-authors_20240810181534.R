# Install and load required packages
# install.packages(c("ggplot2", "maps", "tmap", "tmaptools", "sf", "dplyr"))
library(ggplot2)
library(maps)
library(tmap)
library(tmaptools)
library(sf)
library(dplyr)

# Define file path for coordinates
coords_file <- "data/coords.RDS"

# Function to load existing coordinates or initialize if file does not exist
load_coords <- function(file_path) {
  if (file.exists(file_path)) {
    return(readRDS(file_path))
  } else {
    return(data.frame(location = character(), lon = numeric(), lat = numeric(), stringsAsFactors = FALSE))
  }
}

# Function to save coordinates to file
save_coords <- function(coords, file_path) {
  saveRDS(coords, file_path)
}

# Load existing coordinates
existing_coords <- load_coords(coords_file)

# Extract unique locations from your data
locations <- as.data.frame(table(paste0(last_author_cmr_location$affil_city, ", ", last_author_cmr_location$affil_country)))
locations$location <- as.character(locations$Var1)
locations$Var1 <- NULL

# Identify new locations (not present in existing_coords)
new_locations <- setdiff(locations$location, existing_coords$location)

# Function to geocode a location using OSM
geocode_location <- function(location) {
  result <- geocode_OSM(location)
  if (!is.null(result)) {
    return(data.frame(location = location, lon = result$coords[1], lat = result$coords[2], stringsAsFactors = FALSE))
  } else {
    return(data.frame(location = location, lon = NA, lat = NA, stringsAsFactors = FALSE))
  }
}

# Geocode only new locations
new_coords <- do.call(rbind, lapply(new_locations, geocode_location))

# Combine new coordinates with existing coordinates
updated_coords <- bind_rows(existing_coords, new_coords)

# Save updated coordinates
save_coords(updated_coords, coords_file)

# Combine the coordinates with the original data for visualization
locations_with_coords <- merge(locations, updated_coords, by = "location", all.x = TRUE)

# Convert to sf object
locations_sf <- st_as_sf(locations_with_coords, coords = c("lon", "lat"), crs = 4326)

# Load the world map
world <- st_as_sf(maps::map("world", plot = FALSE, fill = TRUE))

# Plotting
p <- ggplot(data = world) +
  geom_sf(fill = "grey") +
  geom_sf(data = locations_sf, aes(size = Freq), color = "red", alpha = 0.7) +
  theme_minimal() +
  labs(title = "Last Authors for CMR-related Publications, 2017-2024",
       subtitle = "Based on their institutional affiliation",
       caption = "Source: Scopus") +
  theme(legend.position = "bottom")