# Load required libraries
library(rgbif)
library(dplyr)
library(ggplot2)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)

# Download occurrence data for Macaca cyclopis from gbif
gbif_macaca <- occ_search(
  scientificName = "Macaca cyclopis",
  hasCoordinate = TRUE,
  basisOfRecord = "HUMAN_OBSERVATION",
  limit = 1000
)

# Extract only the data frame from the result
gbif_macaca_data <- gbif_macaca$data

# Convert the occurrence data to an sf object
macaca_sf <- st_as_sf(
  gbif_macaca_data,
  coords = c("decimalLongitude", "decimalLatitude"),
  crs = 4326 # WGS 84 coordinate system
)


# Load the world map
world <- ne_countries(scale = "medium", returnclass = "sf")


# Plot the map without projection to verify data points
ggplot(data = world) +
  geom_sf(fill = "lightgray", color = "white") +
  geom_sf(data = macaca_sf, color = "red", size = 1.5) +
  coord_sf(xlim = c(119, 123), ylim = c(21, 26), expand = FALSE) +
  theme_minimal() +
  labs(title = "Distribution of Macaca cyclopis in Taiwan",
       x = "Longitude",
       y = "Latitude")



#####
# Define a projection suitable for Taiwan
taiwan_projection <- "+proj=lcc +lat_1=25 +lat_2=47 +lon_0=121"

# Transform the world and occurrence data to this projection
world_proj <- st_transform(world, crs = taiwan_projection)
macaca_proj <- st_transform(macaca_sf, crs = taiwan_projection)

# Plot the projected map
ggplot(data = world_proj) +
  geom_sf(fill = "lightgray", color = "white") +
  geom_sf(data = macaca_proj, color = "red", size = 1.5) +
  coord_sf(xlim = c(119, 123), ylim = c(21, 26), expand = FALSE) +
  theme_minimal() +
  labs(title = "Projected Distribution of Macaca cyclopis in Taiwan",
       x = "Longitude",
       y = "Latitude")
##Empty map :(
