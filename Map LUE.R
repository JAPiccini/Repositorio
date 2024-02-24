library(readxl)
library(dplyr)
library(geobr)
library(st)
library(sf)
library(leaflet)
library(plotly)

#Puxando o banco de dados
LUE_e_TE <- read_excel("C:/Users/Desktop/Downloads/LUE e TE.xls", 
                       sheet = "Variacoes")

X2017 <- read_excel("2017.xlsx")

#Coletando o shapefile
map <- read_municipality(year = 2017)

#Alterando o dataframe
map <- map[ grep("MT", map$abbrev_state) , ]
map <- map[ grep("Ponte Branca", map$name_muni, invert = TRUE) , ]

#Juntando os dados
data <- merge(LUE_e_TE, X2017, by = "name_muni")
data <- merge(data, map, by="name_muni")

#Analisando os dados
summary(data$LUE)
summary(data$LUE17)
hist(data$LUE, xlab = "Eficiência", ylab = "Frequência", main = "")
#histograma empilhado dos dois censos
plot_ly(x = data$LUE, type = "histogram") %>%
  layout(title = "",
         xaxis = list(title = "Eficiência",
                      zeroline = FALSE),
         yaxis = list(title = "Frequência",
                      zeroline = FALSE))
plot_ly(x = data$LUE17, type = "histogram") %>%
  layout(title = "",
         xaxis = list(title = "Eficiência",
                      zeroline = FALSE),
         yaxis = list(title = "Frequência",
                      zeroline = FALSE))

#Alterando o formato do arquivo
data <- st_as_sf(data)

#Alterando  formato do arquivo novamente
data <- as(data, "Spatial")

#Definindo o formato da coluna municipios
Encoding(data$name_muni) <- "UTF-8"

#Mapa variação LUE
pal <- colorBin(palette = "RdYlGn", domain = data@data$LUE , na.color="transparent")

state_popup <- paste0("<strong>Município: </strong>",
                      data$name_muni,
                      "<br><strong>Variação LUE : </strong>",
                      data$LUE)
leaflet(data = data) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(fillColor = ~pal(data$LUE),
              fillOpacity = 1.0,
              color = "#BDBDC3",
              weight = 1,
              popup = state_popup) %>%
  addLegend("bottomright", pal = pal, values = ~data$LUE,
            title = "Variação Eficiência do Uso da Terra",
            opacity = 1)

#Mapa LUE 2017
pal <- colorBin(palette = "BuGn", domain = data@data$LUE17 , na.color="transparent")

state_popup <- paste0("<strong>Município: </strong>",
                      data$name_muni,
                      "<br><strong>Variação LUE : </strong>",
                      data$LUE17)
leaflet(data = data) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(fillColor = ~pal(data$LUE17),
              fillOpacity = 1.0,
              color = "#BDBDC3",
              weight = 1,
              popup = state_popup) %>%
  addLegend("bottomright", pal = pal, values = ~data$LUE17,
            title = "Eficiência do Uso da Terra 2017",
            opacity = 1)
