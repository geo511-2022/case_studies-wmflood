library(ggplot2)
library(gapminder)
library(dplyr)

gap_filter = filter(gapminder, !country == "Kuwait")
##Filtering out the data set to remove Kuwait. The ! needs to go before row to denote a negation.

##Plot 1
gdp_lifExp_plot = ##Need to adjust the legend to be more ledgable
  ggplot(gap_filter, aes(x=lifeExp, y=gdpPercap, group=continent)) + ##group command groups rows together based on a similar column
  geom_point(aes(color=continent, size=pop/100000)) + ##the color command separates the groups into colors, the size command differentiates them into different sizes
  facet_wrap(~year,nrow=1) + ##separates each individual graph by the year column and denotes that they should all fill 1 row
  scale_y_continuous(trans = "sqrt") + ##this command tells the scale to apply to all of the graphs, but it also scales I think logerithmically
  theme_bw() + 
  labs(title = "GDP vs Life Expectancy",
       x = "Life Expectancy", 
       y = "GDP per Capita", 
       size ="Population (100k)",
       color ="Continent") ##Labels 
gdp_lifExp_plot

png("CS03_p1.png", width = 15, height = 5, units = "in", res = 300)
gdp_lifExp_plot
dev.off()

##Plot 2
gapminder_continent = gap_filter %>% 
  group_by(continent, year) %>%
  summarise(gdpPercapweighted = weighted.mean(x = gdpPercap, w = pop),
            pop = sum(as.numeric(pop)))

gdp_year_cont = ggplot(gap_filter, aes(x=year, y=gdpPercap))+
  geom_line(aes(color=continent, group=country))+
  geom_point(aes(color=continent, group=country))+
  geom_line(data=gapminder_continent, aes(x=year, y=gdpPercapweighted))+
  geom_point(data=gapminder_continent, aes(x=year, y=gdpPercapweighted, size=pop/100000))+
  facet_wrap(~continent, nrow=1)+
  theme_bw()+
  labs(title = "GDP over time by contintnet",
       x = "Year",
       y = "GDP Per Capita",
       size="Population (100k)",
       color="Continent")
gdp_year_cont

png("CS03_p2.png", width = 15, height = 5, units = "in", res = 300)
gdp_year_cont
dev.off()
