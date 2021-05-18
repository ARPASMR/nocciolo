#---------------------------------------
#
# calcolo media su periodo da dati mensili
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


cartella<-paste("../IDIt/med_mese/",sep="")
print(cartella)

for (mese in c("01","02","03","04","05","06","07","08","09","10","11","12")) {

#stringa_ricerca=paste("IDIm[:digit:]",mese,".asc",sep="")
#print(stringa_ricerca)

#elenco dei file (per contarli)
#nomefile<-list.files(path=cartella, pattern=stringa_ricerca, full.names=FALSE)
#numero_anni<-length(nomefile)
#print(numero_anni)

#if (numero_anni != 17 ) { 
#  print(paste(" mese: ",mese," con dati incompleti (trovo ",numero_anni," files.",sep=""))
#  quit()
#} 

IDI <- raster(paste(cartella,"IDIm_2002",mese,".asc",sep=""))

for (anno in seq(2003,2019)) {
#datainizio<-strptime(paste(anno,mese,"01",sep=""),"%Y%m%d")
#print("a inizio ciclo:")
#print(datainizio)
#ciclo sui giorni
#  datainizio <-datainizio+60*60*24
#  print(format(datainizio,"%Y%m%d"))

  IDInext<-raster(paste(cartella,"IDIm_",anno,mese,".asc",sep=""))
  IDI<-sum(IDI,IDInext)
  }

IDI<-IDI/18

#scrivi preci mensili
writeRaster(IDI, file=paste("../IDIt/medie/IDIm_",mese,".asc",sep=""), format="ascii", overwrite=TRUE)

} # fine ciclo mesi

#media totale:
IDI<-raster(paste("../IDIt/medie/IDIm_01.asc",sep=""))
for (mese in c("02","03","04","05","06","07","08","09","10","11","12")) {
  IDInext<-raster(paste("../IDIt/medie/IDIm_",mese,".asc",sep=""))
  IDI<-sum(IDI,IDInext)
}
IDI<-IDI/12
writeRaster(IDI, file=paste("../indici/IDIm.asc",sep=""), format="ascii", overwrite=TRUE)
q()
