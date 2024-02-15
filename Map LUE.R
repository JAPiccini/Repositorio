library(readxl)
library(dplyr)
library(geobr)
library(st)
library(leaflet)

#Puxando o banco de dados
LUE_e_TE <- read_excel("C:/Users/Desktop/Downloads/LUE e TE.xls", 
                       sheet = "Variacoes")

#Coletando o shapefile
map <- read_municipality(year = 2017)

#Alterando o dataframe
map <- map[ grep("MT", map$abbrev_state) , ]
map <- map[ grep("Ponte Branca", map$name_muni, invert = TRUE) , ]

#Juntando os dados
data <- merge(LUE_e_TE, map, by="name_muni")

#Alterando o formato do arquivo
data <- st_as_sf(data)

#Alterando  formato do arquivo novamente
data <- as(data, "Spatial")

#Definindo a projeção o mapa
proj4string(data)

#Definindo o formato da coluna municipios
Encoding(data$name_muni) <- "UTF-8"

#Definindo legendas e coloração do mapa
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
