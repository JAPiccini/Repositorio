library(shiny)
library(shinyWidgets)
library(leaflet)
library(tidyverse)

#UI (do inglês, user interface) definirá a aparência do aplicativo Shiny
ui <- bootstrapPage(
  leafletOutput("map", width = "100%", height = "100%"),

  absolutePanel(right = 0,
                pickerInput("estados", label = "Selecione um Estado:",
                choices = list("Todos os Estados",
                               "Amapá", "Roraima", "Acre", "Amazonas", "Pará",
                               "Maranhão", "Piauí", "Ceará", "Rio Grande do Norte",
                               "Pernambuco", "Paraíba", "Alagoas", "Sergipe",
                               "Tocantins", "Rondônia", "Goiás", "Distrito Federal",
                               "Mato Grosso", "Bahia", "Minas Gerais", "Espírito Santo",
                               "São Paulo", "Rio de Janeiro", "Paraná", "Santa Catarina",
                               "Rio Grande do Sul")),
                options = list(

                  'live-search' = TRUE)



 )
)

