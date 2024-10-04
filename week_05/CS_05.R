#Install packages
install.packages("spData")
install.packages("sf")
install.packages("tidyverse")

#Load data and packages for task 5
library (spData)   #data for case 5
library(dplyr)     #For data manipulation
library(sf)        #For handling spatial data
library(ggplot2)   #For plotting

#Data===============Load data from the spData package
data(world)
# load 'states' boundaries from spData package
data(us_states)
# plot(world[1])          #plot if desired
# plot(us_states[1])      #plot if desired
# plot "world" using gglot2

#Working with world dataset
# Transform to albers equal area projections
albers="+proj=aea +lat_1=29.5 +lat_2=45.5 
+lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 
+datum=NAD83 +units=m +no_defs"

## Data Processing
Canada_only <- world %>% filter(name_long== "Canada") %>% select(geom)
Newyork_only <- us_states %>% filter(NAME== "New York") %>% select(geometry)

# Define Projection
albers="+proj=aea +lat_1=29.5 +lat_2=45.5 
+lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 
+ellps=GRS80 +datum=NAD83 +units=m +no_defs"

#Transform data
Canada_only <- st_transform(Canada_only, albers)
Newyork_only <- st_transform(Newyork_only, albers)

# Create a 10 km (10,000 meters) buffer around Canada
Canada_buffered <- st_buffer(Canada_only, dist = 10000)  # 10 km = 10,000 meters

# Use st_intersection() to intersect the Canada buffer with New York state
border <- st_intersection(Canada_buffered, Newyork_only)

# Visualizing the data
ggplot() +
  geom_sf(data = Newyork_only) +
  geom_sf(data = border, colour = "red", fill = "red") +
  ggtitle("New York Land within 10km")


