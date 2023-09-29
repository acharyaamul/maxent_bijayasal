#### Load Packages####
library(raster) # load tif file
library(usdm) # VIF (variance Inflation Factor)measures the severity of multicollinearity in regression analysis. 
library(predicts)
library("RColorBrewer")
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

#terra::writeRaster(preds,"./data/raster_afVIF.tif",overwrite=TRUE)
#### Load Presence file###
bijay_data<-vect("./data/bijaya_wgs_thined.shp")
nepal<-vect("./data/nepal_boundary.shp")
r<-rast("./data/raster_afVIF.tif")
names(r)
plot(r)
####Run Maxent Model####
max_bijay <- MaxEnt(r,bijay_data,args=c("-J","-P")) 

#### save the results###
max_bijay@path

source_file<-max_bijay@path
dir.create("maxent_results")
destination_folder<-"./maxent_results/"
file.copy(source_file,destination_folder,recursive = T,overwrite = T)
#### Save Variables Contribution#####
jpeg(file="./maxent_results/Variable_Inportance.jpeg")
plot(max_bijay)
dev.off()

####Predict ####
bijaya_pred <- predict(max_bijay,r)
plot(bijaya_pred)
plot(nepal,add=T)
plot(bijay_data,pch=1,cex=0.5,col="blue",add=T)
#writeRaster(bijaya_pred,"./maxent_results/maxent_bijaya.tif",overwrite=TRUE)
m <- c(0, 0.2, 1,
       0.2, 0.4, 2,
       0.4, 0.6, 3,
       0.6,1, 4)
rclmat <- matrix(m, ncol=3, byrow=TRUE)
maxent_reclass <- classify(bijaya_pred, rclmat, include.lowest=TRUE)
plot(maxent_reclass,col=brewer.pal(n = 4, name = "RdBu"))
#writeRaster(maxent_reclass,"./maxent_results/maxent_bijaya_reclass.tif",overwrite=TRUE)
