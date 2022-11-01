library(sf)
library(tidyverse)
library(ggmap)
library(rnoaa)
library(spData)


data(world)
data(us_states)

#Download zipped data from noaa with storm track information
dataurl="https://www.ncei.noaa.gov/data/international-best-track-archive-for-climate-stewardship-ibtracs/v04r00/access/shapefile/IBTrACS.NA.list.v04r00.points.zip"
tdir=tempdir()
download.file(dataurl,destfile=file.path(tdir,"temp.zip"))
#unzip the compressed folder
unzip(file.path(tdir,"temp.zip"),exdir = tdir) 
storm_data <- read_sf(list.files(tdir,pattern=".shp",full.names = T))
#filtering the storm data to only include 1950 to present
stormData = storm_data %>%
  filter(SEASON > 1949) %>%
  mutate_if(is.numeric, function(x) ifelse(x==-999.0,NA,x)) %>%
  mutate(decade=(floor(year/10)*10))
#creating a region using a bounding box
region = st_bbox(stormData)
#making the plot
storm_map = ggplot(world) +
  geom_sf() +
  facet_wrap(~decade) +
  stat_bin2d(data=stormData, 
             aes(y=st_coordinates(stormData)[,2], 
                 x=st_coordinates(stormData)[,1]),bins=100) +
  scale_fill_distiller(palette="YlOrRd", 
                       trans="log", 
                       direction=-1, 
                       breaks = c(1,10,100,1000)) + #to set the color ramp
  coord_sf(ylim=region[c(2,4)], xlim=region[c(1,3)]) #to crop the plot to the region
storm_map
#calculating the five states with the most storms
states = st_transform(us_states, crs = st_crs(stormData)) #reprojecting the data
colnames(states)[2] = "state" #renaming the NAME column to state
storm_states <- st_join(stormData, states, join = st_intersects,left = F)
storms_top5 = storm_states %>%
  group_by(state) %>%
  summarise(storms=length(unique(NAME))) %>%
  arrange(desc(storms)) %>%
  st_set_geometry(NULL) %>%
  slice(1:5)
storms_top5
