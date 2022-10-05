library(sf) 
library(tidyverse)
library(spData)
library(units)


data("world") #pulling the world data from spData
data("us_states") #pulling from spData

albers="+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0
+ellps=GRS80 +datum=NAD83 +units=m +no_defs"

world_a = st_transform(world, albers)
us_states_a = st_transform(us_states, albers)

canada = filter(world_a, name_long == "Canada")
buff_canada = st_buffer(canada, dist = 10000)

newYork = filter(us_states_a, NAME == "New York")

can_ny = st_intersection(buff_canada, newYork)

can_ny_border = ggplot(can_ny)+ geom_sf()
can_ny_border

border_area = st_area(can_ny)

units(border_area) <- as_units("km^2")

##Extra time leaflet map
library(leaflet)

leaflet(border_area) %>%
  addTiles() %>%
  addPolygons()
