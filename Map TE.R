library(readxl)
library(dplyr)
library(geobr)
library(st)
library(sf)
library(leaflet)

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

#Análise descritiva 
summary(data$TE)
summary(data$TE17)

#Alterando o formato do arquivo
data <- st_as_sf(data)

#Alterando  formato do arquivo novamente
data <- as(data, "Spatial")

#Definindo o formato da coluna municipios
Encoding(data$name_muni) <- "UTF-8"

#Mapa Variação TE
pal <- colorBin(palette = "RdYlGn", domain = data@data$TE , na.color="transparent")

state_popup <- paste0("<strong>Município: </strong>",
                      data$name_muni,
                      "<br><strong>Variação Eficiência Técnica : </strong>",
                      data$TE)
leaflet(data = data) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(fillColor = ~pal(data$TE),
              fillOpacity = 1.0,
              color = "#BDBDC3",
              weight = 1,
              popup = state_popup) %>%
  addLegend("bottomright", pal = pal, values = ~data$TE,
            title = "Variação Eficiência Técnica",
            opacity = 1)

#Mapa TE 2017
pal <- colorBin(palette = "Greens", domain = data@data$TE17 , na.color="transparent")

state_popup <- paste0("<strong>Município: </strong>",
                      data$name_muni,
                      "<br><strong>Variação LUE : </strong>",
                      data$TE17)
leaflet(data = data) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(fillColor = ~pal(data$TE17),
              fillOpacity = 1.0,
              color = "#BDBDC3",
              weight = 1,
              popup = state_popup) %>%
  addLegend("bottomright", pal = pal, values = ~data$TE17,
            title = "Eficiência Técnica 2017",
            opacity = 1)
