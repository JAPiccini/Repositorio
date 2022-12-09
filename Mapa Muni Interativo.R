library(dplyr)
library(sf)
library(st)
library(sp)
library(here)
library(stars)
library(terra)
library(RColorBrewer)
library(leaflet)
library(readr)
library(janitor)


setwd("~/Projeto")

tabela01 <- read_csv("tabela01.csv")

#tabela01 <- tabela01 %>%
  group_by(municipios) %>%
  mutate(cumsum = cumsum(PG))

tabela01 <- as.data.frame(tabela01)

shapefile <- st_read(here("br_municipios_2017", "BRMUE250GC_SIR.shp"))

shapefile <- setNames(shapefile, c("municipios","codigo", "geometry"))

shapefile <- shapefile%>%
  mutate(across(c(codigo), as.numeric))

shapefile <- subset( shapefile, select = -municipios )

mapapg <- full_join(tabela01, shapefile, by = 'codigo')

mapapg[is.na(mapapg)] <- 0

mapapg <- mapapg %>%
  mutate(across(!municipios, as.numeric))%>%
  mutate(across(c(codigo,municipios), as.numeric))

mapapg <- st_as_sf(mapapg)

mapapg<- as(mapapg, "Spatial")

proj4string(mapapg)

Encoding(mapapg$municipios) <- "UTF-8"

pal <- colorBin("Greens",domain = NULL,n = 5)

state_popup <- paste0("<strong>Estado: </strong>",
                      mapapg$municipios,
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

wri

