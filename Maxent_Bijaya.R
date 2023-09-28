#### Load Packages####
library(raster) # load tif file
library(usdm) # VIF (variance Inflation Factor)measures the severity of multicollinearity in regression analysis. 
library(predicts)
####Load Worldclim Data ####
ls.dir<-"./data/wc2.1_30s_bio/"
rlst <- list.files(ls.dir, pattern = "*.tif$",full.names = T)
worldclim<-rast(rlst)
names(worldclim)
projection(worldclim)
####Load DEM data ####
elevation<-rast("./data/nepal_dem90m.tif")
elev<-resample(elevation,worldclim, method="bilinear")
#slope and Aspect from DEM
slope<- terrain(elev, "slope", unit= "degrees", neighbors=8)
aspect <- terrain(elev, "aspect",unit= "degrees", neighbors=8) 
imag_com<-c(worldclim,elev,slope,aspect)
names(imag_com)
class(imag_com)
terra::writeRaster(imag_com,"./data/imag_com.tif",overwrite=TRUE)
v <- vifstep(imag_com, th=10)
v
preds <- exclude(imag_com,v)
names(preds)
class(preds)
plot(preds)

terra::writeRaster(preds,"./data/raster_afVIF.tif",overwrite=TRUE)
#### Load Presence file###
bijay_data<-vect("./data/bijaya_wgs_thined.shp")
nepal<-vect("./data/nepal_boundary.shp")
r<-rast("./data/raster_afVIF.tif")
names(r)
plot(r)
####Run Maxent Model####
max_bijay <- MaxEnt(r,bijay_data) 
plot(max_bijay)
####Predict ####
bijaya_pred <- predict(max_bijay,r)
plot(bijaya_pred)
plot(nepal,add=T)
plot(bijay_data,pch=1,cex=0.5,col="blue",add=T)
terra::writeRaster(preds,"./data/maxent_bijaya.tif",overwrite=TRUE)

