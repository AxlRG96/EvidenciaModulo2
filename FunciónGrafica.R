library(httr)
library(jsonlite)
library("dplyr")
library(reshape2)
library(plotly)
urlS <- "http://localhost:4000/api/reporteb/hoja123"
bodyS <- toJSON(list(
                list("fecha1"="2021-02-01",
                     "fecha2"="2021-03-20",
                     "fechat1"="2021-03-01",
                     "fechat2"="2021-03-20",
                     "hora"="17",
                     "sitios1"=list(
                       list("sitio"="SA1-A-1")
                     ),
                     "sitios2"=list(
                       list("sitio"="SA1-A-1")
                     )
                     )
                )
               , auto_unbox=TRUE)

r <- POST(urlS, body = bodyS,content_type("application/json"))
dataS <- content(r)
lec = dataS$h1[[1]]$lecturas
caudal <- lec[[1]]$caudal
volumen <- lec[[1]]$volumen
vola <- lec[[1]]$vola
flec <- as.Date(lec[[1]]$fechalectura)

for (i in 2:length(lec)){
  caudal <- append(caudal,lec[[i]]$caudal)
  volumen <- append(volumen,lec[[i]]$volumen)
  vola <- append(vola,lec[[i]]$vola)
  flec <- append(flec,as.Date(lec[[i]]$fechalectura))
}

dataF <- data.frame(flec,volumen,vola,caudal);
test_data_long <- melt(dataF, id="flec")
ggplotly(ggplot(data=test_data_long,
       aes(x=flec, y=value, colour=variable)) +
  geom_line(size=1)
)

