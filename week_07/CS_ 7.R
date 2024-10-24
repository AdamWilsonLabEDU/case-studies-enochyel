
#Install packages
install.packages("reprex") #reprex package


#load library
library(tidyverse)         #tidyverse, sf, and spdata already installed
library(reprex)
library(sf)
library(spData)

#Load data
data(world)

#Generate a plot (attempted plot)

ggplot(world,aes(x=gdpPercap, y=continent, color=continent))+
  geom_density(alpha=0.5,color=F)

#Run reprex (reproducible example)
reprex(venue="gh")

