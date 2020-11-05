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


cartella<-paste("../ET0/mensili/",sep="")
print(cartella)

for (mese in c("01","02","03","04","05","06","07","08","09","10","11","12")) {

stringa_ricerca=paste("ET0_[:digit:]",mese,".asc",sep="")
print(stringa_ricerca)

#elenco dei file (per contarli)
#nomefile<-list.files(path=cartella, pattern=stringa_ricerca, full.names=FALSE)
#numero_anni<-length(nomefile)
#print(numero_anni)

#if (numero_anni != 17 ) { 
#  print(paste(" mese: ",mese," con dati incompleti (trovo ",numero_anni," files.",sep=""))
#  quit()
#} 

PRECI <- raster(paste(cartella,"/ET0_2005",mese,".asc",sep=""))

for (anno in seq(2006,2019)) {
#datainizio<-strptime(paste(anno,mese,"01",sep=""),"%Y%m%d")
#print("a inizio ciclo:")
#print(datainizio)
#ciclo sui giorni
#  datainizio <-datainizio+60*60*24
#  print(format(datainizio,"%Y%m%d"))

  PRECInext<-raster(paste(cartella,"/ET0_",anno,mese,".asc",sep=""))
  PRECI<-sum(PRECI,PRECInext)
  }

PRECI<-PRECI/15

#scrivi preci mensili
writeRaster(PRECI, file=paste("../ET0/medie/MEDIA_ET0_",mese,".asc",sep=""), format="ascii", overwrite=TRUE)

} # fine ciclo mesi

q()
