#Install packages
install.packages("tidyverse")
#Install data
install.packages("nycflights13")

#Load packages
library("tidyverse")
library("nycflights13")

#Explore dataset
nycflights13::airlines
nycflights13::airports
nycflights13::flights
nycflights13::planes
nycflights13::weather

#View dataset
airlines
airports
planes
weather
flights
glimpse(flights)
glimpse(airports)
glimpse(airlines)
glimpse(planes)


# OBJECTIVE 1: full name of destination airport farthest from any NYC airports in flights table.
#Select destination and distances
farthest_flight_wholeTable <- flights %>%
  filter(flights$origin=='JFK') %>%
  arrange(desc(distance)) %>%
  select(dest, distance, origin)

view(farthest_flight_wholeTable)
#Join data
farthest_airport_details <- farthest_flight_wholeTable %>%
  left_join(airports, by = c("dest" = "faa")) %>%
  slice(1) %>%
  select(name)
farthest_airport_details



