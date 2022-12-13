library(shiny)
library(leaflet)

#Server definirá o funcionamento do app Shiny

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  output$mapapg <- renderLeaflet({
    pal <- colorBin("Greens",domain = NULL,n = 5)

    state_popup <- paste0("<strong>Estado: </strong>",
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


})


