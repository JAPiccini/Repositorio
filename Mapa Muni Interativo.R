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
library(spData)

#Definindo o diretório padrão
setwd("~/Projeto")

#Lendo o arquivo com os dados de lavoura temporária
tabela01 <- read_csv("tabela01.csv")

#Definindo que o arquivo mude para dataframe
tabela01 <- as.data.frame(tabela01)

#Lendo o arquivo com a localização dos municípios
shapefile <- st_read(here("br_municipios_2017", "BRMUE250GC_SIR.shp"))

#Renomeando colunas do arquivo
shapefile <- setNames(shapefile, c("municipios","codigo", "geometry"))

#Alterando o formato da coluna do arquivo
shapefile <- shapefile%>%
  mutate(across(c(codigo), as.numeric))

#Reirando a coluna municipios do arquivo( Municípios com escrita desconfigurada)
shapefile <- subset( shapefile, select = -municipios )

#Juntado os shapes com os dados
mapapg <- full_join(tabela01, shapefile, by = 'codigo')

#Juntando os estados com os municípios
mapapg <- inner_join(mapapg, ibge, by = 'codigo')

#Alterando NAs para 0
mapapg[is.na(mapapg)] <- 0

#Alterando a configuraçõ das colunas
mapapg <- mapapg %>%
  mutate(across(!municipios, as.numeric))%>%
  mutate(across(c(codigo,municipios), as.numeric))

#Alterando o formato do arquivo
mapapg <- st_as_sf(mapapg)

#Alterando  formato do arquivo novamente
mapapg<- as(mapapg, "Spatial")

#Definindo a projeção o mapa
proj4string(mapapg)

#Definindo o formato da coluna municipios
Encoding(mapapg$municipios) <- "UTF-8"

#Definindo legendas e coloração do mapa
pal <- colorBin(palette = "Greens", domain = mapapg@data$Total , na.color="transparent")

state_popup <- paste0("<strong>Município: </strong>",
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

#Salvando o arquivo no formato para utilizá-lo no Shiny
saveRDS(mapapg, file = "mapapg1.rds")
