library(ggplot2)
library(dplyr)
library(tidyverse)

dataurl="https://data.giss.nasa.gov/tmp/gistemp/STATIONS/tmp_USW00014733_14_0_1/station.txt"
httr::GET("https://data.giss.nasa.gov/cgi-bin/gistemp/stdata_show_v4.cgi?id=USW00014733&ds=14&dt=1")
temp=read_table(dataurl,
                skip=3, #skip the first line which has column names
                na="999.90", # tell R that 999.90 means missing in this dataset
                col_names = c("YEAR","JAN","FEB","MAR", # define column names 
                              "APR","MAY","JUN","JUL",  
                              "AUG","SEP","OCT","NOV",  
                              "DEC","DJF","MAM","JJA",  
                              "SON","metANN"))
#View(temp)
#summary(temp)
#glimpse(temp)

temp_plot = ggplot(temp, aes(x=YEAR, y=JJA))+
  geom_line()+
  ggtitle("Mean Summer Temperatures in Buffalo")+
  theme(plot.title = element_text(hjust = 0.5))+
  geom_smooth()+
  xlab("Year")+
  ylab("Mean Summer Temp (C)")
temp_plot

png(file = "Buff_Temp_CS2.png", width = 480, height = 300)
temp_plot
dev.off()

##there is an interaction between scale size and font size, may need to adjust 
##font size to incorporate 
##png better for graphs and line drawings, jpeg better for pictures or raster

##The summers are indeed getting hotter. Other tests that could be run would be
##to look at the median temperature and create a visualization of that, or to 
##look at the highest temperature for each summer.


#Akureyri Summer Temp graph

dataurl2 = "https://data.giss.nasa.gov/tmp/gistemp/STATIONS/tmp_IC000004063_14_0_1/station.txt"
httr::GET("https://data.giss.nasa.gov/cgi-bin/gistemp/stdata_show_v4.cgi?id=USW00014733&ds=14&dt=1")
akureyri_temp=read_table(dataurl2,
                skip=3,
                na="999.90",
                col_names = c("YEAR","JAN","FEB","MAR", 
                              "APR","MAY","JUN","JUL",  
                              "AUG","SEP","OCT","NOV",  
                              "DEC","DJF","MAM","JJA",  
                              "SON","metANN"))

View(akureyri_temp)

a_temp_plot = ggplot(akureyri_temp, aes(x=YEAR, y=JJA))+
  geom_line()+
  ggtitle("Mean Summer Temperatures in Akureyri")+
  theme(plot.title = element_text(hjust = 0.5))+
  geom_smooth()+
  xlab("Year")+
  ylab("Mean Summer Temp (C)")
a_temp_plot

library(gridExtra)
grid.arrange(temp_plot, a_temp_plot, ncol=2)
