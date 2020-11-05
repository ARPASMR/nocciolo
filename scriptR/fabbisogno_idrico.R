#---------------------------------------
#
# calcolo min med max giorno da dati ora
#
#---------------------------------------

#librerie
#-------------------------
library(raster)
library(sp)
library(rgdal)
#library(grid)
#library(gridExtra)

#--------------------------
# file ornalieri in cartelle mensili
#--------------------------


cartellaET0<-paste("../ET0/medie/",sep="")
cartellaPP<-paste("../PREC/medie/",sep="")
print(cartellaET0)
print(cartellaPP)

coefficiente_k <- c(0,0,0,0.25,0.6,0.65,0.85,0.9,0.8,0,0,0)
i <- 1
for (mese in c("01","02","03","04","05","06","07","08","09","10","11","12")) {

ET0 <- raster(paste(cartellaET0,"MEDIA_ET0_",mese,".asc",sep=""))
PP <- raster(paste(cartellaPP,"CUMULATA_MEDIA_",mese,".asc",sep=""))

FABBISOGNO <- ET0*coefficiente_k[i] - PP

#scrivi preci mensili
i <- i+1
} # fine ciclo mesi

writeRaster(FABBISOGNO, file="../indici/fabbisogno.asc", format="ascii", overwrite=TRUE)

q()
