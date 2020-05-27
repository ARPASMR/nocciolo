Dati e script per ottenere:

-  un dataset di temperature giornaliere minime, medie e massime su grigliato gauus boaga 1.5km dai dati orari di temperatura della rete meteo regionale lombarda (periodo 2002-2019).

-  un dataset di precipitazioni giornaliere su stesso grigliato/periodo, da cui estrapolare poi la precipitazione cumulata media mensile.

-  un dataset di evapotraspirazione potenziale giornaliera su stesso grigliato/periodo, da cui estrapolare poi la cumulata media mensile

-  un dataset di temperatura massima e umidità relativa media oraria, su stesso grigliato, per poter calcolare il VPD (Vapor pressure deficit)



Obbiettivo:

Calcolare i seguenti indici e la loro attribuzione e rappresentazione in classi di suitability su stesso grigliato:

    1. percentuale di anni nel periodo 2002-2019 con gelate invernali [n. di anni in cui si verica la temperatura < -10°C per almeno un giorno, durante il periodo Dicembre-gennaio-febbraio-marzo]/[anni totali]; l'indice è espresso in termini percentuali e le classi di suitability sono le seguenti: S1 (0-10%),  S2(10,01-20%), S3 (20,01-30%), S4 o N (>30%).

    2. percentuale di anni nel periodo 2002-2019 con gelate tardive ultima decade di marzo [n. di anni in cui si verica la temperatura < -10°C per almeno un giorno, durante ultima decade di marzo]/[numero di anni totali]; l'indice è espresso in termini percentuali e le classi di suitability sono le seguenti: S1 (0-10%),  S2(10,01-20%), S3 (20,01-30%), S4 o N (>30%).

    3. percentuale di anni nel periodo 2002-2019 con gelate primaverili [n. di anni in cui si verica la temperatura < -2°C per almeno un giorno, durante il periodo aprile-maggio ]/[numero di anni totali]; l'indice è espresso in termini percentuali (n. anni gelate/n. anni tot della serie) e le classi di suitability sono le seguenti: S1 (0-10%),  S2(10,01-20%), S3 (20,01-30%), S4 o N (>30%).

    4. il calcolo del deficit idrico mensile [(Somma ET0 x Kc (coefficente colturale mensile nocciolo))-Somma PP]. L'indice è espresso come somma del fabbisogno (o del surplus) durante la fase vegetativa del nocciolo, ovvero da aprile a settembre. le classi di deficit sono le seguenti: deficit_4 (230-150 mm),  deficit_3(150-100mm), deficit_2 (100-50 mm), deficit_1 (50-0 mm), surplus 1(0-50 mm), surplus2 (50-160 mm).

    5. indice di stress termico, espresso come il perdurare oltre le tre ore consecutive di un VPD > di 30 mbar. Calcolo del VPD (Ea-Ed) Ea: pressione di vapore a saturazione a data T; Ed: pressione di vapore effettiva a data T°C. le due pressioni di vapore sono calcolate a partire da Tmax e UR orarie. l0indice è espresso come n. medio di giorni/anno, in cui si verifica questa condizione. le classi di suitability sono le seguenti: S1 (0-10),  S2(10,01-20), S3 (20,01-30), S4 o N (>30).