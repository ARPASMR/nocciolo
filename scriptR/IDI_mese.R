#---------------------------------------
#
# calcolo min med mensili dell'IDI 
#
#---------------------------------------

#librerie
#-------------------------
# ATT: prima lanciare comando:
# export LD_LIBRARY_PATH=/home/meteo/libR/lib
library(raster)
library(sp)
library(rgdal)
#library(grid)
#library(gridExtra)

#--------------------------
# file ornalieri in cartelle mensili
#--------------------------

#mese<-"06" 
#anno<-"2015"
for (anno in seq(2019,2002,by=-1)) {
for (mese in c("01","02","03","04","05","06","07","08","09","10","11","12")) { 
#trovo la directory giusta
cartella<-paste("../IDIt/med_giorno/",sep="")
print(cartella)
#elenco dei file (per contarli)
nomefile<-list.files(path=cartella,pattern=paste("IDIm",anno,mese,"[0-9][0-9].asc",sep=""), full.names="F")
print(nomefile)
numero_giorni<-length(nomefile)
print(numero_giorni)
if (numero_giorni < 28 ||  numero_giorni > 31 ) { 
  print(paste("Mese: ",mese," e anno: ",anno," con dati incompleti (trovo ",numero_giorni," files.",sep=""))
  quit()
} 
datainizio<-strptime(paste(anno,mese,"01",sep=""),"%Y%m%d")
print("a inizio ciclo:")
print(datainizio)
IDI <- raster(paste(cartella,"IDIm",format(datainizio,"%Y%m%d"),".asc",sep=""))
#values(PRECI)[which(is.na(values(PRECI)))] <- 0

#ciclo sui giorni
for (g in 2:numero_giorni) {
  datainizio <-datainizio+60*60*24
  print(format(datainizio,"%Y%m%d"))
  IDInext<-raster(paste(cartella,"IDIm",format(datainizio,"%Y%m%d"),".asc",sep=""))
#  values(PRECInext)[which(is.na(values(PRECInext)))] <- 0
  IDI<-sum(IDI,IDInext)
} #fine ciclo giorni
IDI<-IDI/numero_giorni
#scrivi preci mensili
writeRaster(IDI, file=paste("../IDIt/med_mese/IDIm_",format(datainizio,"%Y%m"),".asc",sep=""), format="ascii", overwrite=TRUE)
print("a fine ciclo:")
print(datainizio)
} # fine ciclo mesi
}
q()
