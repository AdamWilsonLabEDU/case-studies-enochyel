#Install packages
install.packages("sf")
install.packages("spData")
install.packages("tidyverse")


#Load packages in libraries for task 5
library(sf)
library(spData)
library(tidyverse)


#Data===============Load data
data("world")   #load 'world data from spData package

data("us_states")       #Load 'states' boundaries from the spData

plot(world[1])          #plot if desired

plot (us_states[1])     #plot if desired


#Working with world dataset
# Transform to albers equal area projections
albers="+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 
+x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"

#Data Processing

canada_only<- world %>%
  filter(name_long == "Canada") %>%
  select(geom)       #filter Canada from the world data 
NewYork_only<- world %>%
  filter(name == "New York") %>%
  select(geom)      #filter New York State
world
#Create a border object
albers="+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 
+lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m 
+no_defs"

canada_only <- st_transform(canada_only, albers)
NewYork_only <- st_transform(NewYork_only, albers)


