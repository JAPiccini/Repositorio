library(dplyr)
library(sf)
library(st)
library(here)
library(stars)
library(terra)
library(RColorBrewer)
library(leaflet)
library(readr)
library(janitor)

setwd("~/Projeto")

codigo <- read_delim("sera.csv", delim = ";", 
                   escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"), 
                   trim_ws = TRUE)

shp <- st_read(here("br_unidades_da_federacao_2017" , "BRUFE250GC_SIR.shp"))

st_transform(shp)

hectares<- read.csv("tabela008.csv")

hectares <- hectares %>%
  group_by(unifedera) %>%
  mutate(cumsum = cumsum(PG))

hectares <- hectares %>%
group_by(unifedera) %>%
  summarise(Total=max(Total))

hectares <- as.data.frame(hectares)

hectares <- merge(codigo,hectares, by.x = "NOME", by.y = "unifedera")

mapa <- merge(shp,hectares, by.x = "CD_GEOCUF", by.y = "SIGLA")

mapapg <- merge(shp,hectares, by.x = "CD_GEOCUF", by.y = "COD")

proj4string(mapapg) <- spTransform(mapapg,CRS("+proj=longlat"))

Encoding(mapapg$NM_ESTADO) <- "UTF-8"

pal <- colorBin("Greens",domain = NULL,n = 5)

state_popup <- paste0("<strong>Estado: </strong>", 
                      mapapg$NM_ESTADO, 
                      "<br><strong>Hectares: </strong>", 
                      mapapg$Total)
leaflet(data = mapapg) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(fillColor = ~pal(mapapg$Total), 
              fillOpacity = 1.0,
              color = "#BDBDC3", 
              weight = 1,
              popup = state_popup) %>%
  addLegend("bottomright", pal = pal, values = ~mapapg$Total,
            title = "Área Colhida(ha)",
            opacity = 1)
class(mapapg)
st_transform(shp) 
