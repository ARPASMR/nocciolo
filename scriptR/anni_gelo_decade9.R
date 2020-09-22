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
cartella <- "../T2m/min_giorno/"

#qui mettere il ciclo
for (anno in seq(2002,2019)) {

ggelo <-raster(paste(cartella,"Tmin20020101.asc",sep=""))
values(ggelo)[which(!is.na(values(ggelo)))] <- 0
names(ggelo)<-"ggelo"

somma <-raster(paste(cartella,"Tmin20020101.asc",sep=""))
values(somma)<-NA
values(somma)[which(!is.na(values(ggelo)))] <- 0
names(somma)<-"somma"

#elenco file da processare
stringa<-'\"' 
print(stringa)

cat(stringa)


stringa<-"03\\(2\\|3\\).\\.asc"
print(stringa)
cat(stringa)
pause()

comando <- paste0("ls -1 ",cartella,"Tmin",anno,"*.asc | grep '03\(2\|3\).\.asc'",sep="")
#omando <- paste("ls -1 ",cartella,'Tmin',anno,'*.asc | grep "\\(04\\|05\\)..\\.asc"  -',sep="")
print(comando)
print(nomefile)
nomefile <- readLines(pipe(comando))
i<-1
while ( i <= length(nomefile) ) {
  print(nomefile[i]) # per debug
  temp<-raster(nomefile[i])
  values(somma)[which(values(temp) < -2)] <- 1
  print(max(somma))
  ggelo<-ggelo+somma
  values(somma)<-0
  i<-i+1
} #fine ciclo file dell'anno

writeRaster(ggelo, file=paste("../indici/ggelo_decade9_",anno,".txt",sep=""), format="ascii", overwrite=T)

} #fine ciclo anni
