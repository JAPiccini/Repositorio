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
tabela01munic <- read_csv("tabela01munic.csv")

#Definindo que o arquivo mude para dataframe
tabela01munic <- as.data.frame(tabela01munic)

#Lendo o arquivo com a localização dos municípios
municshp <- st_read(here("br_municipios", "BRMUE250GC_SIR.shp"))

#Renomeando colunas do arquivo
municshp <- setNames(municshp, c("municipios","codigo", "geometry"))

#Alterando o formato da coluna do arquivo
municshp <- municshp %>%
  mutate(across(c(codigo), as.numeric))

#Reirando a coluna municipios do arquivo( Municípios com escrita desconfigurada)
municshp <- subset( municshp, select = -municipios )

#Juntado os shapes com os dados
municmapapg <- full_join(tabela01munic, municshp, by = 'codigo')


#Juntando os estados com os municípios          ATENÇÃO, NÃO ENCONTROU A COLUNA IBGE
municmapapg <- inner_join(municmapapg, ibge, by = 'codigo')

#Alterando NAs para 0
municmapapg[is.na(municmapapg)] <- 0

#Alterando a configuraçõ das colunas
municmapapg <- municmapapg %>%
  mutate(across(!municipios, as.numeric))%>%
  mutate(across(c(codigo,municipios), as.numeric)) # NESTA ULTIMA LINHA VC ESTÁ TRANSFORMANDO CODIGO E MUNICIPIOS EM NUMERICO. É ISSO?

#Alterando o formato do arquivo
municmapapg <- st_as_sf(municmapapg)

#Alterando  formato do arquivo novamente
municmapapg<- as(municmapapg, "Spatial")

#Definindo a projeção o mapa
proj4string(municmapapg)

#Definindo o formato da coluna municipios
Encoding(municmapapg$municipios) <- "UTF-8"

#Definindo legendas e coloração do mapa
pal <- colorBin(palette = "Greens", domain = municmapapg@data$Total , na.color="transparent")

state_popup <- paste0("<strong>Município: </strong>",
                      municmapapg$municipios,
                      "<br><strong>Hectares: </strong>",
                      municmapapg$Total)

leaflet(data = municmapapg) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(fillColor = ~pal(municmapapg$Total),
              fillOpacity = 1.0,
              color = "#BDBDC3",
              weight = 1,
              popup = state_popup) %>%
  addLegend("bottomright", pal = pal, values = ~municmapapg$Total,
            title = "Área Colhida(ha)",
            opacity = 1)

#Salvando o arquivo no formato para utilizá-lo no Shiny
saveRDS(municmapapg, file = "mapapg1.rds")
