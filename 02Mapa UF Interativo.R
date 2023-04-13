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
library(rgdal)

setwd("~/Projeto")

ufcod <- read_delim("ufcod.csv", delim = ";",
                   escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"),
                   trim_ws = TRUE)

#Baixar o shape no site: https://portaldemapas.ibge.gov.br/

ufshp <- st_read(here("br_unidades_da_federacao" , "BRUFE250GC_SIR.shp"))



st_transform(ufshp)

ufhectares<- read.csv("tabela01uf.csv")

#### Não entendi o pq destes codigos com group_by e tb não funcionou ####

ufhectares <- ufhectares %>%
  group_by(unifedera) %>%
  mutate(cumsum = cumsum(PG))

ufhectares <- ufhectares %>%
group_by(unifedera) %>%
  summarise(Total=max(Total))

#### Retomando ####
ufhectares <- as.data.frame(ufhectares)

ufhectares <- merge(ufcod,ufhectares, by.x = "NOME", by.y = "unifedera")

ufmapa <- merge(ufshp,ufhectares, by.x = "CD_GEOCUF", by.y = "SIGLA")

#### o que é o pg ####
ufmapapg <- merge(ufshp,ufhectares, by.x = "CD_GEOCUF", by.y = "COD")

#não funcionou
proj4string(ufmapapg) <- spTransform(ufmapapg,CRS("+proj=longlat"))

Encoding(ufmapapg$NM_ESTADO) <- "UTF-8"

pal <- colorBin("Greens",domain = NULL,n = 5)

state_popup <- paste0("<strong>Estado: </strong>",
                      ufmapapg$NM_ESTADO,
                      "<br><strong>Hectares: </strong>",
                      ufmapapg$Total)

leaflet(data = ufmapapg) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(fillColor = ~pal(ufmapapg$Total),
              fillOpacity = 1.0,
              color = "#BDBDC3",
              weight = 1,
              popup = state_popup) %>%
  addLegend("bottomright", pal = pal, values = ~ufmapapg$Total,
            title = "Área Colhida(ha)",
            opacity = 1)
class(ufmapapg)
st_transform(ufshp)

