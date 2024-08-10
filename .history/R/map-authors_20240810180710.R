# install.packages("ggplot2")
# install.packages("maps")
library(ggplot2)
library(maps)
library(tmap)
library(tmaptools)

locations <- as.data.frame(table(paste0(last_author_cmr_location$affil_city, ", ", last_author_cmr_location$affil_country)))

locations$location <- as.character(locations$Var1)
locations$Var1 <- NULL


# Function to geocode locations
geocode_locations <- function(location) {
  result <- geocode_OSM(location)
  if (!is.null(result)) {
    return(data.frame(lon = result$coords[1], lat = result$coords[2]))
  } else {
    return(data.frame(lon = NA, lat = NA))
  }
}

# Apply geocoding to the locations
coords <- do.call(rbind, lapply(locations$location, geocode_locations))

# Combine the coordinates with the original data
locations <- cbind(locations, coords)

locations_sf <- st_as_sf(locations, coords = c("lon", "lat"), crs = 4326)

locations_sf <- locations_sf |> mutate(mytext = paste(
  "City: ", location
))


# Load the world map from naturalearth
world <- st_as_sf(maps::map("world", plot = FALSE, fill = TRUE))

library(ggrepel)

p <- ggplot(data = world) +
  geom_sf(fill = "grey") +  # Draw the world map
  geom_sf(data = locations_sf, aes(size = Freq), color = "red", alpha = 1) +  # Plot the locations with correct color and alpha
  #geom_sf_label(data = locations_sf, aes(label = location), size = 0.5)+
  theme_minimal() +
  labs(title = "Last Authors for CMR-related Publications, 2017-2024",
       subtitle = "Based on their institutional affiliation",
       caption = "Source: Scopus") +
  theme(legend.position = "bottom") #+ geom_label_repel(data = locations_sf, aes(label = location, geometry = geometry),stat = "sf_coordinates", min.segment.length = 0)

p
#library(plotly)
#ggplotly(p, tooltip = "text")

