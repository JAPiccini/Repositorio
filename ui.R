library(shiny)
library(leaflet)
library(datasets)

#UI (do inglês, user interface) definirá a aparência do aplicativo Shiny
ui <- fluidPage(
  fluidPage(titlePanel = "Mapa Lavoura Temporária", #Inserindo título na página
            hr(), # inserir uma linha,
            img(scr="https://via.placeholder.com/150"), #URL para inserir uma img na pag futuramente
            "Área Colhida em Hectares",
            #hr(), # inserir uma linha,
            leafletOutput("mapapg")),
  # Gerando uma linha com uma barra lateral
  sidebarLayout(

    # Defindo a barra lateral com uma entrada
    sidebarPanel(
      selectInput("municipios", "Municípios:",
                  choices=colnames(mapapg)),
      hr(),
      helpText("Dados do Censo Agropecuário 2017 IBGE.")
    ),

    # Criando um local para o gráfico de barras
    mainPanel(
      plotOutput("mapa")
    )

))

