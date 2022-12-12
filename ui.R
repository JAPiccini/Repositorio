library(shiny)
library(leaflet)
library(datasets)

ui <- fluidPage(
  fluidPage(title = "Mapa Lavoura Temporária",
            hr(), # inserir uma linha
            "Área Colhida em Hectares no Censo Agropecuário de 2017",
            #hr(), # inserir uma linha,
            leafletOutput("mapapg")),
  # Gerando uma linha com uma barra lateral
  sidebarLayout(

    # Defindo a barra lateral com uma entrada
    sidebarPanel(
      selectInput("region", "Região:",
                  choices=colnames(mapapg)),
      hr(),
      helpText("Dados do Censo Agropecuário 2017 IBGE.")
    ),

    # Criando um local para o gráfico de barras
    mainPanel(
      plotOutput("mapa")
    )

))

