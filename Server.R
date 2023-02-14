library(shiny)
library(leaflet)
library(tidyverse)
library(shinyWidgets)

# Define server logic para fazer o mapa no Shiny
shinyServer <- function(input, output, session) {

  output$map <- renderLeaflet({
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
  })

  filteredData <- reactive({
    if(input$estados == "Todos os Estados") {
      mapapg
    } else {
      filter(mapapg, Estados ==input$estados)
    }
  })
}
