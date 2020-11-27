#---------------------------------------
#
# calcolo VDP da dati orari T2m e RH
#
#---------------------------------------

#
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

#mese<-"06" 
#anno<-"2015"

VDP_medio <- raster("../T2m/dati_orari/200201/TEMP2m_2002010101UTCplus1.txt")
values(VDP_medio)[which(!is.na(values(VDP_medio)))] <- 0 #metto a zero tutti i valori non NA

for (anno in seq(2002,2019,by=1)) {

VDP_anno<- raster("../T2m/dati_orari/200201/TEMP2m_2002010101UTCplus1.txt")
values(VDP_anno)[which(!is.na(values(VDP_anno)))] <- 0 #metto a zero tutti i valori non NA

for (mese in c("01","02","03","04","05","06","07","08","09","10","11","12")) { 
#trovo la directory giusta
cartellaT<-paste("../T2m/dati_orari/",anno,mese,sep="")
print(cartellaT)
cartellaUR<-paste("../UR/orarie/",anno,mese,sep="")
print(cartellaUR)
#elenco dei file (per contarli)
nomefile<-list.files(path=cartellaT)
numero_file=length(nomefile)
numero_giorni=numero_file/24
print(numero_giorni)
if (numero_giorni < 28 ||  numero_giorni > 31 ) { 
  print(paste("Mese: ",mese," e anno: ",anno," con dati incompleti (trovo ",numero_giorni*24," files.",sep=""))
  quit()
} 
datainizio<-strptime(paste(anno,mese,"01","01",sep=""),"%Y%m%d%H")
print(datainizio)
#ciclo sui giorni
for (g in 1:numero_giorni) {
#primo file del giorno
print("a inizio ciclo:")
print(datainizio)

VDP_giorno <- raster(paste(cartellaT,"/TEMP2m_",format(datainizio,"%Y%m%d%H"),"UTCplus1.txt",sep=""))
values(VDP_giorno)[which(!is.na(values(VDP_giorno)))] <- 0 #metto a zero tutti i valori non NA 
VDP_next<- raster(paste(cartellaT,"/TEMP2m_",format(datainizio,"%Y%m%d%H"),"UTCplus1.txt",sep=""))
values(VDP_next)[which(!is.na(values(VDP_next)))] <- 0 #metto a zero tutti i valori non NA
VDP_1<- raster(paste(cartellaT,"/TEMP2m_",format(datainizio,"%Y%m%d%H"),"UTCplus1.txt",sep=""))
values(VDP_1)[which(!is.na(values(VDP_1)))] <- 0 #metto a zero tutti i valori non NA
VDP_2<- raster(paste(cartellaT,"/TEMP2m_",format(datainizio,"%Y%m%d%H"),"UTCplus1.txt",sep=""))
values(VDP_2)[which(!is.na(values(VDP_2)))] <- 0 #metto a zero tutti i valori non NA
VDP_temp<- raster(paste(cartellaT,"/TEMP2m_",format(datainizio,"%Y%m%d%H"),"UTCplus1.txt",sep=""))
values(VDP_temp)[which(!is.na(values(VDP_temp)))] <- 0 #metto a zero tutti i valori non NA


#ciclo sulle ore del giorno
for (ora in 0:23) {
        datanext<-datainizio+60*60*ora

	tnext<-raster(paste(cartellaT,"/TEMP2m_",format(datanext,"%Y%m%d%H"),"UTCplus1.txt",sep=""))
        URnext<-raster(paste(cartellaUR,"/UR_",format(datanext,"%Y%m%d%H"),"UTCplus1.txt",sep=""))


#calcolo VDP: Ea-Ed=Ea-RH*Ea/100= (1-RH/100)*Ea =(1-RH/100) * 6.108* exp(17.269*T/(237.3+T))   - tetens formula
        VDP_next<- calc(tnext,fun=function(x){6.108*exp((x*17.269/(x+237.3)))})
        URnext<-URnext/(-100.)
        URnext<-URnext+1
        VDP_next<-URnext*VDP_next
#       VPD_next<-(1-URnext/100)*6.108*exp((tnext*17.269/(tnext+237.3))) #così non funziona la raster algebra...spezzato i conti in più passaggi
        if ( !is.finite(cellStats(VDP_next,stat='max'))) { 
	print(format(datanext,"%Y%m%d%H"))
	print("esco da iterazione")
        next }
#scrivi conteggio 1 se VDP>30 , 0 altrimenti  
        values(VDP_next)[which(values(VDP_next)<30)] <- 0 #metto a zero tutti i valori inferiori a 30 hPa
        values(VDP_next)[which(values(VDP_next)>=30)] <- 1 #metto a 1 (ora di stress) tutti i valori superiori a 30 hPa
        if (ora == 0 ) { VDP_1 <- VDP_next}
        if (ora == 1 ) { VDP_2 <- VDP_1
	VDP_1<-VDP_next }
        if (ora > 1 ) { 
        VDP_temp <- sum(VDP_2,VDP_1,VDP_next) 
        VDP_2 <- VDP_1
        VDP_1 <- VDP_next
        values(VDP_giorno)[which(values( VDP_temp == 3 )) ]  <- 1 
        }    
}

#writeRaster(VDP_giorno, file=paste("../UR/temp/VDP_",format(datainizio,"%Y%m%d"),".txt",sep=""), format="ascii", overwrite=TRUE)
# metto a 1 i punti griglia in cui ho avuto almeno tre ore NON CONSECUTIVE di stress idrico
#values(VDP_giorno)[which(  (values(VDP_giorno) < 3) & (!is.na(values(VDP_giorno)))  )] <- 0 #metto a zero tutti i grid non NA in cui non ci sono almeno 3 ore di stress
#values(VDP_giorno)[which(  values(VDP_giorno) < 3 )] <- 0 #metto a zero tutti i grid non NA in cui non ci sono almeno 3 ore di stress
#values(VDP_giorno)[which(  values(VDP_giorno) >= 3)] <- 1 #metto a 1 tutti i grid non NA in cui ci sono almeno 3 ore di stress

VDP_anno<-sum(VDP_anno,VDP_giorno)

#writeRaster(VDP_giorno, file=paste("../UR/temp/VDP_",format(datainizio,"%Y%m%d"),"_2.txt",sep=""), format="ascii", overwrite=TRUE)
#aggiorna la data del primo file
datainizio<-datainizio+60*60*24
#print("a fine ciclo:")
#print(datainizio)
} # fine ciclo giorni
} # fine ciclo mesi
VDP_medio<-mean(VDP_medio,VDP_anno)
writeRaster(VDP_anno, file=paste("../indici/VDP_annuo_",anno,".asc",sep=""), format="ascii", overwrite=TRUE)
} #fine ciclo anni
writeRaster(VDP_medio, file="../indici/VDP_medio_annuo.asc", format="ascii", overwrite=TRUE)
print("fine conti")
q()
