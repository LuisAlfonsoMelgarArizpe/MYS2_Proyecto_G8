# Simio 2021 May Student Competition
## Demand Driven Materials Requirement Planning (DDMRP)
### Fase 1

### SIMI∞S

|Carnet|Nombre|
|-|-|
|201602820|Luis Alfonso Melgar Arizpe|
|201602916|Ricardo Antonio Menéndez Tobías|
|201612141|Diego Estuardo Gómez Fernández|
|201602420|Ingrid Rossana Pérez Mena|


## Diseño del sistema

### Procesos

### Elementos


## Analisis para distribuciones

### Metodo 1
Para analizar la informacion del procesamiento de materiales en cada una de sus estaciones (Hoja Processing Data) realizaron los siguientes pasos:

1. Se carga el archivo CSV que contiene los tiempos en segundos de los diferentes pasos.
2. Se obtienen las diferentes combinaciones de Productos y Estaciones.
3. Configuramos la funcion DistPlus de la libreria EnvStats para que nos ayude a encontrar la distribucion de probabilidades que mas se acerca al grupo de datos. Las configuraciones realizadas fueron las siguientes:
    - Los datos a evaluar (Tiempo en segundos)
    - El error tipo 1 asociado a la prueba.
    - El metodo para elegir la distribucion (Para este caso se utilizo el metodo Shapiro-Wilk)
    - Las distibuciones a evaluar (Gamma, Weibull y Normal).
4. Ejecutamos la funcion DistPlus para encontrar la distribucion elegida.
5. Utilizando la funcion Fitdist de la libreria FitDistrPlus calculamos los parametros obtenidos para la distribucion elegida.
6. Almacenamos los resultados en una matriz.
7. Al finalizar todas las combinaciones, se escribe la matriz en un archivo de Excel.

```R
library(MASS)
library(survival)
library(fitdistrplus)
library(rriskDistributions)
library(dplyr)
library(utf8)
library(EnvStats)
library("xlsx")

data <- read.csv(file.choose(), header = TRUE, sep = ";",na.strings = c("","NA"),colClasses=c("numeric","character","character","character"))

disitruciones <- c("gamma","weibull","exp","norm")

names(distribuciones) <- c("Gamma","Weibull","Exponential","Normal")

nombres <- data[,c("Producto","Estacion")]

nombres = na.omit(nombres)

combinaciones <- nombres %>% distinct(Producto,Estacion)

excel = matrix(1:2,nrow=nrow(combinaciones),ncol=5)

for (i in 1:dim(combinaciones)[1]){
  
filtro_producto <- combinaciones[i,1]
filtro_estacion <- combinaciones[i,2]

datos <- filter(data, Estacion == filtro_estacion & Producto == filtro_producto)

resultado <- distChoose(datos$�..Tiempo, alpha = 0.05, method = "sw",
           choices = c( "gamma" , "weibull"  ,"norm"), est.arg.list = NULL,
           warn = TRUE, keep.data = TRUE, data.name = NULL,
           parent.of.data = NULL, subset.expression = NULL)

resultado
if(resultado$decision == "Nonparametric") {
  resultado$decision = "Normal"
}

resultado_dist <- distribuciones[[resultado$decision]][2]

ajuste <- fitdist(datos$�..Tiempo, resultado_dist)

excel[i,1] <- filtro_estacion
excel[i,2] <- filtro_producto
excel[i,3] <- resultado$decision
excel[i,4] <- ajuste[[1]][1]
excel[i,5] <- ajuste[[1]][2]

cat(sprintf("Para la combinacion %s y %s la dist. es : %s (%s) \n",filtro_producto,filtro_estacion,resultado$decision,resultado_dist))
}

write.xlsx(excel, "Distribuciones Processing Data.xlsx", sheetName = "Distribuciones Processing Data", 
           col.names = FALSE, row.names = FALSE, append = FALSE)

```

Extracto de la salida que genera el archivo:

|Estacion|Producto|Distribucion|P1|P2|
|-|-|-|-|-|
|SA_Cut_1|B22_SA|Normal|121.913612565445|15.9257233074546|
|FA_Cut_2|B22_FA|Normal|231.065656565657|12.9992514284567|
|FA_Cut_1|B22_FA|Normal|229.094240837696|13.1165344007269|
|BP_Cut_1|B22_BP|Normal|127.6|7.08458547491322|
|SA_Routing_1|B22_SA|Normal|31.911838790932|1.792732570611|
|BP_Drill_1|B22_BP|Normal|339.95|22.4700832854964|
|SA_Drill_1|B22_SA|Normal|341.742647058824|23.7830254357059|


Este metodo se utilizo para la hoja de Processing Data debido a la cantidad de datos que esta contiene. Existen mas de 36,000 tomas de datos para los tiempos de procesamiento, y aproximadamente 190 combinaciones de productos y estaciones, por lo que se opto en realizar una eleccion de distribucion de forma automatica en base a un algoritmo para facilitar y optimizar el proceso.
Esto presenta algunas limitaciones como la cantidad de pruebas que se pueden evaluar.


### Metodo 2

## Modelo Final

## Conclusiones

