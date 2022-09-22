library(ggplot2)

data('iris')

?mean
petal_length_mean = mean(iris$Petal.Length, na.rm = TRUE)

?hist
hist(iris$Petal.Length)

ggplot(iris, aes(x=Petal.Length, fill = Species))+
  geom_histogram()+
  facet_grid(. ~ Species)+
  ggtitle("Iris Petal Length")+
  theme(plot.title = element_text(hjust = 0.5))
