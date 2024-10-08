#Install package
library(tidyverse)

#load cvs data using URL
dataurl<- "https://data.giss.nasa.gov/tmp/gistemp/STATIONS_v4/tmp_USW00014733_14_0_1/station.csv"

httr::GET("https://data.giss.nasa.gov/cgi-bin/gistemp/stdata_show_v4.cgi?id=USW00014733&ds=14&dt=1")


temp=read_csv(dataurl, 
              na="999.90", # tell R that 999.90 means missing in this dataset
              skip=1, # we will use our own column names as below so we'll skip the first row
              col_names = c("YEAR","JAN","FEB","MAR", # define column names 
                            "APR","MAY","JUN","JUL",  
                            "AUG","SEP","OCT","NOV",  
                            "DEC","DJF","MAM","JJA",  
                            "SON","metANN"))

#Plot graph
plot<- ggplot(temp, aes(x=YEAR, y=JJA)) + 
  geom_line() +
  geom_smooth(color= "red") +
  xlab("Years") + 
  ylab("Summer Mean Temp") +
  ggtitle("Trend Analysis of Summer Temp")

#Save plot
plot
ggsave("C2.pdf", plot)

ggsave("C2.png", plot)
?geom_smooth
getwd()

temperature_records

head(temperature_records)

#create JJA dataset

month_jja<-c(6, 7, 8)

print(month_jja)
head(month_jja)

jja_data <- temperature_records %>%
  filter(., month %in% c(6, 7, 8)) %>%  # Use `%in%` for filtering
  group_by(year) %>%
  summarize(mean_temp = mean(temp, na.rm = TRUE))
names(temperature_records)
temperature_records$month <- as.numeric(as.character(temperature_records$month))
