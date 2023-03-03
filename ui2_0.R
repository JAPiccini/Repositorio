library(shiny)
library(leaflet)
library(shinydashboard)

# Define UI for miles per gallon app ----
ui <- bootstrapPage(
  header <- dashboardHeader(
    title = "Produção Total de Lavouras Temporárias por Município",
    titleWidth = 1000),
  
  sidebar <- dashboardSidebar(
    sidebarMenu(
      id = "menu_tabs",
      selectInput("STORE_NAME", label = "Município",
                choices = mapapg3$municipios),
    actionButton("go", "Filtrar"))),
  
body <- dashboardBody(
leafletOutput("map", width = "100%", height = 990)
)
)

ui <- dashboardPage(
  header,
  sidebar,
  body)