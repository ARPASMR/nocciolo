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

#mese<-"06" 
#anno<-"2015"
for (anno in seq(2002,2019)) {
for (mese in c("01","02","03","04","05","06","07","08","09","10","11","12")) { 
#trovo la directory giusta
cartella<-paste("../PREC/giornaliere/",anno,mese,sep="")
print(cartella)
#elenco dei file (per contarli)
nomefile<-list.files(path=cartella)
numero_giorni<-length(nomefile)

print(numero_giorni)
if (numero_giorni < 28 ||  numero_giorni > 31 ) { 
  print(paste("Mese: ",mese," e anno: ",anno," con dati incompleti (trovo ",numero_giorni," files.",sep=""))
  quit()
} 
datainizio<-strptime(paste(anno,mese,"01",sep=""),"%Y%m%d")
print("a inizio ciclo:")
print(datainizio)
PRECI <- raster(paste(cartella,"/PRECI_",format(datainizio,"%Y%m%d"),"UTCplus1.txt",sep=""))
#ciclo sui giorni
for (g in 2:numero_giorni) {
  datainizio <-datainizio+60*60*24
  print(format(datainizio,"%Y%m%d"))
  PRECInext<-raster(paste(cartella,"/PRECI_",format(datainizio,"%Y%m%d"),"UTCplus1.txt",sep=""))
  PRECI<-sum(PRECI,PRECInext)
} #fine ciclo giorni
#scrivi preci mensili
writeRaster(PRECI, file=paste("../PREC/mensili/PRECI_",format(datainizio,"%Y%m"),".txt",sep=""), format="ascii", overwrite=TRUE)
print("a fine ciclo:")
print(datainizio)
} # fine ciclo mesi
}
q()
