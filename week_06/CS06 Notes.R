library(raster)
library(sp)
library(spData)
library(tidyverse)
library(sf)

data(world)  #load 'world' data from spData package

#Worldclim website not loading data set, used alternate data set
library(ncdf4)
download.file("https://crudata.uea.ac.uk/cru/data/temperature/absolute.nc","crudata.nc")
tmean=raster("crudata.nc") #need to add method="curl" to the download.file for windows

world6 = filter(world, !continent == "Antarctica") 
world6_sp = as(world6, "Spatial") #saved object as a new sp object

plot(tmean)
#gain(tmean) <- 0.1 (did not need this step with this data set) 

tmax_annual = max(tmean)
names(tmax_annual) = "tmax"

tmax_country = raster :: extract(tmax_annual, world6_sp,
                  fun=max, na.rm=TRUE, small=TRUE, sp=TRUE) %>%
  st_as_sf(world6_sp)

tmax_country_plot = ggplot(tmax_country, aes(fill = tmax)) +
  geom_sf() +
  scale_fill_viridis_c(name="Annual\nMaximum\nTemperature (C)") +
  theme(legend.position = 'bottom')
tmax_country_plot

hottest_continents = tmax_country %>% 
  group_by(continent) %>% #groups by the continents 
  select(name_long, continent, tmax) %>% #selected the three columns to keep
  arrange(.by_group = TRUE) %>% #arranged the table by the group_by
  st_set_geometry(NULL) %>% #removed the geometry from the tmax_country
  slice_max(order_by = tmax) #sliced the highest value for each group by the tmax
  
