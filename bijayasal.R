setwd("~/00_work/00_bijaysal")
list.files()
library(sf)
library(mapview)
library(raster)
library(rgeos)
library(rangeBuilder)
bijaysal<-read.csv("bijasal_presence.csv",header=T)
bijaya_sf<-st_as_sf(bijaysal, coords = c("easting", "northing"), crs = 32644)
bijay_wgs<-st_transform(bijaya_sf,crs=4326)
st_write(bijay_wgs,"~/00_work/00_bijaysal/bijaya_wgs.shp")
##############
bijaya_sp<-as_Spatial(bijay_wgs)
projection(bijaya_sp)
CRS<-"+proj=utm +zone=44 +datum=WGS84 +units=m +no_defs"
bijaya_utm<-spTransform(bijaya_sp,CRS)


