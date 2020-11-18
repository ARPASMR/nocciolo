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


cartella<-paste("../PREC/mensili/",sep="")
print(cartella)

for (mese in c("01","02","03","04","05","06","07","08","09","10","11","12")) {

#stringa_ricerca=paste("PRECI_*",mese,".asc",sep="")
#print(stringa_ricerca)

#elenco dei file (per contarli)
#nomefile<-list.files(path=cartella, pattern=stringa_ricerca, full.names=FALSE)
#numero_anni<-length(nomefile)
#print(numero_anni)

#if (numero_anni != 17 ) { 
#  print(paste(" mese: ",mese," con dati incompleti (trovo ",numero_anni," files.",sep=""))
#  quit()
#} 

PRECI <- raster(paste(cartella,"/PRECI_2002",mese,".asc",sep=""))

for (anno in seq(2003,2019)) {
#datainizio<-strptime(paste(anno,mese,"01",sep=""),"%Y%m%d")
#print("a inizio ciclo:")
#print(datainizio)
#ciclo sui giorni
#  datainizio <-datainizio+60*60*24
#  print(format(datainizio,"%Y%m%d"))

  PRECInext<-raster(paste(cartella,"/PRECI_",anno,mese,".asc",sep=""))
  PRECI<-sum(PRECI,PRECInext)
  }

PRECI<-PRECI/17

#scrivi preci mensili
writeRaster(PRECI, file=paste("../PREC/medie/CUMULATA_MEDIA_",mese,".asc",sep=""), format="ascii", overwrite=TRUE)

} # fine ciclo mesi

#cumulata media annua
PRECI<-raster("../PREC/medie/CUMULATA_MEDIA_01.asc")
for (mese in c("02","03","04","05","06","07","08","09","10","11","12")) {
  PRECInext<-raster(paste("../PREC/medie/CUMULATA_MEDIA_",mese,".asc",sep=""))
  PRECI<-sum(PRECI,PRECInext)
  }

writeRaster(PRECI, file="../PREC/medie/CUMULATA_MEDIA_ANNUA.asc", format="ascii", overwrite=TRUE)

#cumulata media aprile settembre
PRECI<-raster("../PREC/medie/CUMULATA_MEDIA_04.asc")
for (mese in c("05","06","07","08","09")) {
  PRECInext<-raster(paste("../PREC/medie/CUMULATA_MEDIA_",mese,".asc",sep=""))
  PRECI<-sum(PRECI,PRECInext)
  }

writeRaster(PRECI, file="../PREC/medie/CUMULATA_MEDIA_AMGLAS.asc", format="ascii", overwrite=TRUE)



q()
