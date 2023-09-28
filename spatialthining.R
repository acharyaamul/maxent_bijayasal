setwd("~/00_work/00_bijaysal/data")
list.files()
library(sf)
library(mapview)
library(raster)
library(spThin)

bijaysal<-read.csv("bijasal_presence.csv",header=T)
bijaya_sf<-st_as_sf(bijaysal, coords = c("easting", "northing"), crs = 32644)
bijay_wgs<-st_transform(bijaya_sf,crs=4326)
bijaya_sp<-as_Spatial(bijay_wgs)
bijaya_sp@data
b_data<-data.frame(bijaya_sp)

names(b_data)

names(b_data)[3]<- "lon"
names(b_data)[4]<- "lat"

b_data$species<-"bijayasal"

#thinning the points
thinned_data <- thin(
  loc.data = b_data, 
  lat.col = "lat", #latitude, the string name should be modified accordingly
  long.col = "lon", #longitude, the string name should be modified accordingly
  spec.col = "species", #name of the column with species name
  thin.par = 1, #distance of the thinned points
  reps = 1, #number of repetition, for randomness
  locs.thinned.list.return = TRUE, #If true, the ‘list‘ of the data.frame of thinned locs resulting from each replication is returned 
  write.files = T, #whether to create the csv file or not
  max.files = 10, #number of csv files created.
  out.dir = "./data", #output directory in which the folder is created
  out.base = "bijaya", #the name of folders thus created
  write.log.file = F, #whether to create log file or nor 
  log.file = "noct.txt" # create/append log file of thinning run
)


b_points<-read.csv("csv/bijaya_thin1.csv",header=T)
b_sf<-st_as_sf(b_points, coords = c("lon", "lat"), crs = 4326)
plot(b_sf)

mapview(b_sf)+mapview(bijay_wgs)

#write_sf(b_sf,"~/00_work/00_bijaysal/data/bijaya_wgs_thined.shp")
#write_sf(bijay_wgs,"~/00_work/00_bijaysal/data/bijaya_wgs.shp")

###End###


