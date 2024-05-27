library(readxl)
library(dplyr)
library(geobr)
library(st)
library(sf)
library(leaflet)
library(plotly)
library(spData)

#Puxando o banco de dados
setwd("~/TCC")
LUE_e_TE <- read_excel("LUE e TE.xls", 
                       sheet = "Variacoes")

X2017 <- read_excel("2017.xlsx")

X2006 <- read_excel("LUE e TE.xls")
X2006 <- X2006[X2006$ano == '2006',]
X2006 <- X2006[c('name_muni','TE','LUE')]


#Coletando o shapefile
shp <- read_municipality(code_muni = "MT", year = 2017)

#Alterando o dataframe
shp <- shp[ grep("Ponte Branca", shp$name_muni, invert = TRUE) , ]

#Juntando os dados
data <- merge(LUE_e_TE, X2017, by = "name_muni")
data <- merge(data, X2006, by = "name_muni")
data <- merge(data, shp, by="name_muni")

#Análise descritiva
summary(data$LUE)
summary(data$LUE17)

#Analisando os dados
fig <- plot_ly(data, x = ~LUE17, type = 'histogram', name = 'Eficiência Terra 2017', alpha = 1, nbinsx = 10)
fig <- fig %>% add_trace(x = ~LUE, name = 'Eficiência Terra 2006')
fig <- fig %>% layout(yaxis = list(title = 'Frequêcia'), 
                      xaxis = list(title = "Eficiência do Uso da Terra", rangemode = "tozero"), 
                      barmode = 'stack', bargap = 0.1) 
fig <- fig %>%
  layout(
    xaxis = list(zerolinecolor = '#ffff',
                 zerolinewidth = 2,
                 gridcolor = 'ffff'),
    yaxis = list(zerolinecolor = '#ffff',
                 zerolinewidth = 2,
                 gridcolor = 'ffff'),
    plot_bgcolor='#e5ecf6')       

fig

#Alterando o formato do arquivo
data <- st_as_sf(data)

#Alterando  formato do arquivo novamente
data <- as(data, "Spatial")

#Definindo o formato da coluna municipios
Encoding(data$name_muni) <- "UTF-8"

#Mapa variação LUE
pal <- colorBin(palette = "RdYlGn", domain = data@data$Var_LUE , na.color="transparent")

state_popup <- paste0("<strong>Município: </strong>",
                      data$name_muni,
                      "<br><strong>Variação LUE : </strong>",
                      data$Var_LUE)
leaflet(data = data) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(fillColor = ~pal(data$Var_LUE),
              fillOpacity = 1.0,
              color = "#BDBDC3",
              weight = 1,
              popup = state_popup) %>%
  addLegend("bottomright", pal = pal, values = ~data$Var_LUE,
            title = "Variação Eficiência do Uso da Terra",
            opacity = 1)

saveRDS(data, file = "mapa_var_lue.rds")
#Mapa LUE 2017
pal <- colorBin(palette = "BuGn", domain = data@data$LUE17 , na.color="transparent")

state_popup <- paste0("<strong>Município: </strong>",
                      data$name_muni,
                      "<br><strong>Eficiência : </strong>",
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

saveRDS(data, file = "mapa_lue_2017.rds")
#Mapa LUE 2006
pal <- colorBin(palette = "BuGn", domain = data$LUE , na.color="transparent")

state_popup <- paste0("<strong>Município: </strong>",
                      data$name_muni,
                      "<br><strong>Eficiência : </strong>",
                      data$LUE)
leaflet(data = data) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(fillColor = ~pal(data$LUE),
              fillOpacity = 1.0,
              color = "#BDBDC3",
              weight = 1,
              popup = state_popup) %>%
  addLegend("bottomright", pal = pal, values = ~data$LUE17,
            title = "Eficiência do Uso da Terra 2006",
            opacity = 1)
saveRDS(data, file = "mapa_lue_2006.rds")