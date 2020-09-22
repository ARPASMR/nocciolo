#---------------------------------------
#
# calcolo giorni con Tmin < -10° C
#
#---------------------------------------

#librerie
#-------------------------
library(raster)
library(sp)
library(rgdal)

# apro il primo raster e lo etto a NA per usare geometria originale
cartella <- "../indici/"

gelate <-raster(paste(cartella,"ggelo_2_2002.asc",sep=""))
values(gelate)[which(!is.na(values(gelate)))] <- 0
names(gelate)<-"gelate-10"

#qui mettere il ciclo
numero_anni <- 0
for (anno in seq(2002,2019)) {
numero_anni<-numero_anni+1
temporaneo <-raster(paste(cartella,"ggelo_2_",anno,".asc",sep=""))
values(temporaneo)[which(values(temporaneo)>0)] <- 1
values(gelate) <- values(gelate)+values(temporaneo)
}

values(gelate)<-values(gelate)/numero_anni*100

writeRaster(gelate, file="../indici/gelate2.asc", format="ascii", overwrite=T)

q()
