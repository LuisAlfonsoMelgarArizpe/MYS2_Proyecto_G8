install.packages("devtools")
install.packages("utf8")
install.packages("dplyr")
install.packages("fitdistrplus")
install.packages("rriskDistributions")
install.packages("EnvStats")
install.packages("xlsx")

library(MASS)
library(survival)
library(fitdistrplus)
library(rriskDistributions)
library(dplyr)
library(utf8)
library(EnvStats)
library("xlsx")

help("EnvStats")

# LEER CSV
data <- read.csv(file.choose(), header = TRUE, sep = ";",na.strings = c("","NA"),colClasses=c("numeric","character","character","character"))

# LEER XLSX
data <- read.xlsx(file.choose(),1, header=TRUE)

data

disitruciones <- c("gamma","weibull","exp","norm")

names(distribuciones) <- c("Gamma","Weibull","Exponential","Normal")

nombres <- data[,c("Producto","Estacion")]

nombres = na.omit(nombres)


combinaciones <- nombres %>% distinct(Producto,Estacion)

nrow(combinaciones)

excel = matrix(,nrow=nrow(combinaciones),ncol=5)

for (i in 1:dim(combinaciones)[1]){

filtro_producto <- combinaciones[i,1]
filtro_estacion <- combinaciones[i,2]

datos <- filter(data, Estacion == filtro_estacion & Producto == filtro_producto)

resultado <- distChoose(datos$Tiempo, alpha = 0.05, method = "sw",
           choices = c( "gamma" , "weibull"  ,"norm"), est.arg.list = NULL,
           warn = TRUE, keep.data = TRUE, data.name = NULL,
           parent.of.data = NULL, subset.expression = NULL)

if(resultado$decision == "Nonparametric") {
  resultado$decision = "Normal"
}

resultado_dist <- distribuciones[[resultado$decision]][2]

ajuste <- fitdist(datos$Tiempo, resultado_dist)

excel[i,1] <- filtro_estacion
excel[i,2] <- filtro_producto
excel[i,3] <- resultado$decision
excel[i,4] <- ajuste[[1]][1]
excel[i,5] <- ajuste[[1]][2]
cat(sprintf("Para la combinacion %s y %s la dist. es : %s (%s) \n",filtro_producto,filtro_estacion,resultado$decision,resultado_dist))

}

colnames(excel) = c("Estacion","Producto","Distribucion","Parametro_1","Parametro_2")

write.xlsx(excel, "Distribuciones Salida PD.xlsx", sheetName = "Distribuciones Processing Data", 
           col.names = TRUE, 
           row.names = FALSE, append = FALSE)
