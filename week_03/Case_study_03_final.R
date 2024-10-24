#Install packages
install.packages("ggplots")
install.packages("gapminder")
install.packages("dplyr")
## install.packages("usethis")
install.packages("usethis")

#Load library
library(usethis)
use_git_config(user.name = "Enoch Yeleliere", user.email = "enochyel@buffalo.edu") 


#Load packages

library(ggplot2)
library(gapminder) 
library(dplyr)

print(gapminder)

#Filter data (gapminder) to remove Kuwait
gapminder_noKuwait<- filter(gapminder, country != "Kuwait")

View(gapminder_noKuwait)


#Plot 1 graph

ggplot(gapminder_noKuwait, aes(x= lifeExp, y= gdpPercap, 
                               color = continent, size = pop/100000)) +
geom_point() +
  facet_wrap(~year, nrow = 1)+
  scale_y_continuous(trans = "sqrt") +
  theme_bw() +
  labs(x = "Life Expectancy",
       y = "GDP Per Capita",
       size = "Population (100k)",
       color = "Continent")
#Prepare data for second plot
#Group by continent and year
gapminder_continent <- gapminder_noKuwait %>% 
  group_by(continent, year) %>%
  summarise(gdpPercapweighted = weighted.mean(x = gdpPercap, w = pop),
            pop = sum(as.numeric(pop)))
names(gapminder_noKuwait)
#Plot graph 2
ggplot() + 
  geom_line(data = gapminder_noKuwait, mapping = aes(x=year, y=gdpPercap,
                                    color=continent,
                                   group = country)) + 
  geom_point(data = gapminder_noKuwait, mapping = aes(x=year, y= gdpPercap,
                                     color=continent,
                                     group = country)) + 
  geom_line(data = gapminder_continent, mapping = aes(x=year, y=gdpPercapweighted)) + 
  geom_point(data = gapminder_continent, mapping = aes(x=year, y=gdpPercapweighted,
                                             size = pop/100000
                                             )) + 
  facet_wrap(~continent, nrow = 1) + 
  theme_bw() + 
  labs(x = "Year",
       y = "GDP Per Capita",
       size = "Population (100k)",
       color = "Continent",
       title = "Trend analysis of countries GDP Per Capita")
#Save output
ggsave("case_study_03.png", dpi = 300)


