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
# file orari in cartelle mensili
#--------------------------

mese<-"06" 
anno<-"2015"
#trovo la directory giusta
cartella<-paste("../T2m/dati_orari/",anno,mese,sep="")
print(cartella)
#elenco dei file (per contarli)
nomefile<-list.files(path=cartella)
numero_file=length(nomefile)
numero_giorni=numero_file/24
print(numero_giorni)
#data del primo file (ipotizzo in ordine alfabetico, NON robusto, rifare)
datafile<-substr(nomefile,8,17)
giorno<-substr(datafile,7,8)
datainizio<-strptime(paste(anno,mese,"01","01",sep=""),"%Y%m%d%H")
print(datainizio)
#ciclo sui giorni
for (g in 1:numero_giorni) {
#for (g in 1:1) {
#primo file del giorno
print("a inizio ciclo:")
print(datainizio)
tmin <- raster(paste(cartella,"/TEMP2m_",format(datainizio,"%Y%m%d%H"),"UTCplus1.txt",sep=""))
tmed <- raster(paste(cartella,"/TEMP2m_",format(datainizio,"%Y%m%d%H"),"UTCplus1.txt",sep=""))/24
tmax <- raster(paste(cartella,"/TEMP2m_",format(datainizio,"%Y%m%d%H"),"UTCplus1.txt",sep=""))
#ciclo sulle ore del giorno
for (ora in 1:23) {
    datanext<-datainizio+60*60*ora
	print(format(datanext,"%Y%m%d%H"))
	tnext<-raster(paste(cartella,"/TEMP2m_",format(datanext,"%Y%m%d%H"),"UTCplus1.txt",sep=""))
	tmin<-min(tmin,tnext)
	tmed<-tmed+tnext/24
	tmax<-max(tmax,tnext)
}
#scrivi tmin con giorno
writeRaster(tmin, file=paste("../T2m/min_giorno/Tmin",format(datainizio,"%Y%m%d"),".txt",sep=""), format="ascii")
writeRaster(tmed, file=paste("../T2m/med_giorno/Tmed",format(datainizio,"%Y%m%d"),".txt",sep=""), format="ascii")
writeRaster(tmax, file=paste("../T2m/max_giorno/Tmax",format(datainizio,"%Y%m%d"),".txt",sep=""), format="ascii")
#aggiorna la data del primo file
datainizio<-datainizio+60*60*24
print("a fine ciclo:")
print(datainizio)
}
