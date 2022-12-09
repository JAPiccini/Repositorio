library(shiny)
library(leaflet)

shinyUI(
  fluidPage(title = "Mapa Lavoura Temporária",
            hr(), # inserir uma linha
            "Área Colhida em Hectares no Censo Agropecuário de 2017",
            #hr(), # inserir uma linha,
            leafletOutput("mapapg"))

)
