library(shiny)
library(leaflet)
library(RColorBrewer)

#UI (do inglês, user interface) definirá a aparência do aplicativo Shiny
ui <- fluidPage(
            titlePanel = "Mapa Lavoura Temporária", #Inserindo título na página
            sidebarLayout(
              sidebarPanel(
                selectizeInput("municipio", "Selecione um município", choices = c("All",unique(mapapg$municipios))),
                selectizeInput("cultivo", "Selecione um cultivo", choices = c("All",unique(mapapg$Total))),
                actionButton("goButton", "Atualizar"),
            leafletOutput("mapapg"))

,
mainPanel(
  tabsetPanel(
    tabPanel(plotOutput("mapapg"), width = "100%", height = "1000px")
  )
)))
