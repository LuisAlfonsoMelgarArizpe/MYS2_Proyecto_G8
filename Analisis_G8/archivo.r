library("xlsx")

# carga de la data a manipular
#data <- read.csv(file.choose(), header = TRUE, sep = ",")

data <- read.xlsx(file.choose(),3, header=TRUE)
# impreme la data
data

# buscamos alguna distribucion que se pueda asociar a los datos
datos = {}
matriz = matrix(, nrow=7,ncol=5)
i = 0
imatriz = 1
for(i in 1:length(data[,1])){
  celda = data[,1][i]
  if(celda == -1){
    dist <- fit.cont(datos)
    matriz[imatriz,1] = data[,2][i-1]
    matriz[imatriz,2] = data[,3][i-1]
    matriz[imatriz,3] = dist$chosenDistr
    x = 4
    for(param in dist$fittedParams){
      matriz[imatriz,x] = param
      x = x + 1
    }
    imatriz = imatriz + 1
    i = i + 1
    next
  }
  datos = c(datos, celda)
  i = i + 1
}

#write.table(matriz, file = 'resultado-r.xlsx', row.names = FALSE, col.names = c('v1','v2','Distribucion','Param1','Param2'), sep=",")

colnames(matriz) = c('Material','Supplier','Distribucion','Param1','Param2')

write.xlsx(matriz, "Distribuciones Salida.xlsx", sheetName = "Distribuciones Salida", 
           col.names = TRUE, 
           row.names = FALSE, append = FALSE)


