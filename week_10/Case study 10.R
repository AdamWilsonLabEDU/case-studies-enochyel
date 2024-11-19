#Case study 10

#Install packages
install.packages(rasterVis)
#Load packages
library(terra)
library(rasterVis)
library(ggmap)
library(tidyverse)
library(knitr)
library(sf)
# New Packages
library(ncdf4) # to import data from netcdf format

#Case study setup, identify and download folders
#Land use, land cover data
# Create afolder to hold the downloaded data
dir.create("data",showWarnings = F) #create a folder to hold the data

lulc_url="https://github.com/adammwilson/DataScienceData/blob/master/inst/extdata/appeears/MCD12Q1.051_aid0001.nc?raw=true"
lst_url="https://github.com/adammwilson/DataScienceData/blob/master/inst/extdata/appeears/MOD11A2.006_aid0001.nc?raw=true"

# download them
download.file(lulc_url,destfile="data/MCD12Q1.051_aid0001.nc", mode="wb")
download.file(lst_url,destfile="data/MOD11A2.006_aid0001.nc", mode="wb")

#Load data into R
lulc=rast("data/MCD12Q1.051_aid0001.nc",subds="Land_Cover_Type_1")
lst=rast("data/MOD11A2.006_aid0001.nc",subds="LST_Day_1km")

#Explore the data
#Plot the lulc
plot(lulc)

#Plot the lst data
plot(lst)

#Pick one year to work with. Example
lulc=lulc[[13]]
plot(lulc)

#Process land cover data
Land_Cover_Type_1 = c(
  Water = 0, 
  `Evergreen Needleleaf forest` = 1, 
  `Evergreen Broadleaf forest` = 2,
  `Deciduous Needleleaf forest` = 3, 
  `Deciduous Broadleaf forest` = 4,
  `Mixed forest` = 5, 
  `Closed shrublands` = 6,
  `Open shrublands` = 7,
  `Woody savannas` = 8, 
  Savannas = 9,
  Grasslands = 10,
  `Permanent wetlands` = 11, 
  Croplands = 12,
  `Urban & built-up` = 13,
  `Cropland/Natural vegetation mosaic` = 14, 
  `Snow & ice` = 15,
  `Barren/Sparsely vegetated` = 16, 
  Unclassified = 254,
  NoDataFill = 255)

lcd=data.frame(
  ID=Land_Cover_Type_1,
  landcover=names(Land_Cover_Type_1),
  col=c("#000080","#008000","#00FF00", "#99CC00","#99FF99", "#339966", "#993366", "#FFCC99", 
        "#CCFFCC", "#FFCC00", "#FF9900", "#006699", "#FFFF00", "#FF0000", "#999966", "#FFFFFF", 
        "#808080", "#000000", "#000000"),
  stringsAsFactors = F)
# colors from https://lpdaac.usgs.gov/about/news_archive/modisterra_land_cover_types_yearly_l3_global_005deg_cmg_mod12c1
kable(head(lcd))

#Convert LULC raster into a ‘factor’ (categorical) raster
# convert to raster (easy)
lulc=as.factor(lulc)

# update the RAT with a left join
#levels(lulc)=left_join(levels(lulc)[[1]],lcd)[-1,]
#activeCat(lulc)=1

# plot it
gplot(lulc)+
  geom_raster(aes(fill=as.factor(value)))+
  scale_fill_manual(values=setNames(lcd$col,lcd$ID),
                    labels=lcd$landcover,
                    breaks=lcd$ID,
                    name="Landcover Type")+
  coord_equal()+
  theme(legend.position = "right")+
  guides(fill=guide_legend(ncol=1,byrow=TRUE))
#Land surface temperature
plot(lst[[1:12]])

#Convert LST to Degrees C 
#You can convert LST from Degrees Kelvin (K) to Celcius (C) with scoff()
scoff(lst)=cbind(0.02,-273.15)
plot(lst[[1:10]])

#Part 1 extract time series for a point
lw= data.frame(x= -78.791547,y=43.007211) %>% 
  st_as_sf(coords=c("x","y"),crs=4326)

#transform
# Get the projection of the raster 
lw_transf <- st_transform(lw, st_crs(lst))

#Extra the LST data for the location
lst_values=terra::extract(lst,lw,buffer=1000,fun=mean,na.rm=T)

# Transpose the values and drop the first column l
lst_values <- t(lst_values[ -1]) 

# Extract dates for each layer 
lst_dates <- time(lst) 

# Combine the dates and LST values into a data.frame 
lst_combine <- data.frame( Date = lst_dates, 
                           LST = lst_values)

#Plot the data
ggplot(lst_combine, aes(x = Date, y = LST)) + 
  geom_point() + 
  geom_smooth(span = 0.02, method = "loess", se = FALSE, color = "blue") + 
  labs(title = "Time series", 
       x = "Date", 
       y = "LST") + 
  theme_minimal()

#Part 2: Summarize weekly data to monthly climatologies
# summarize the mean value per month 
lst_month <- tapp(lst, index='month', fun=mean, na.rm = TRUE) # apply a function to subsets of layer of a SpatRaster

# set the names of the layers to months
names(lst_month) = month.name[as.numeric(str_replace(names(lst_month),"m_",""))]

# plot the map for each month
gplot(lst_month) + geom_raster(aes(fill = value)) +
  facet_wrap(~ variable) + 
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank()) +
  scale_fill_gradientn(colors = c("blue", "white", "red")) +
  labs(x = 'x', y = 'y')

# calculate the monthly mean for the entire image
global(lst_month, mean, na.rm=T)

#Part 3: Summarize Land Surface Temperature by Land Cover
# Resample lulc to lst grid using resample() with method=near to create a new object called lulc2.
lulc2 <- resample(lulc, lst, method = 'near')
# Extract the values from lst_month and lulc2 into a data.frame as follows:
lcds1 <- cbind.data.frame(values(lst_month), ID=values(lulc2[[1]]))%>% 
  na.omit() 

lcds1 %>% 
  # Gather the data into a ‘tidy’ format
  gather(key='month',value='value',-Land_Cover_Type_1_13) %>%
  # convert ID to numeric 
  mutate(ID=as.numeric(Land_Cover_Type_1_13)) %>% 
  # left join with lcd (lcd: landcover and color table)
  left_join(lcd, by='ID') %>% 
  # filter 
  filter(landcover%in%c("Urban & built-up","Deciduous Broadleaf forest")) %>%
  # visualize
  ggplot(aes(x = month, y = value), alpha = 0.3) +
  geom_jitter() +
  geom_violin(
    alpha = 0.7, fill='#A4A4A4', color="darkred") +
  facet_wrap(~landcover, ncol = 2) +
  labs(x = 'Month', y = 'Monthly Mean Land Surface Temperature (C)') +
  ggtitle('Land Surface Temperature in Urban and Forest')

