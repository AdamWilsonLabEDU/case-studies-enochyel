#Load iris dataset
data(iris)
#remove rm()

#View(iris)

#ggsave
# Calculate the means
?mean

# Mean for petal length
Petal.Length_mean<-mean(iris$Petal.Length)
Petal.Length_mean

# Plot histogram
?hist
hist(iris$Petal.Length)


#Load library
library(ggplot2)
geom_histogram(iris$Petal.Length)
ggplot(iris$Petal.Length)

#Create histogram
ggplot(iris, aes(Petal.Length)) +
  geom_histogram()
ggplot(iris, aes(Petal.Length)) +
  geom_histogram(binwidth = 0.5)
#Other attempts

#Summary tables
summary(iris)

#Explore other analysis
#Maximum values
max_petal_length <- max(iris$Petal.Length)
max_petal_length
#Minimum values
min_petal_length <- min(iris$Petal.Length)
min_petal_length
