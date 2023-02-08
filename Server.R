library(shiny)
library(leaflet)
library(ggplot2)

#Server definirá o funcionamento do app Shiny
data1 <- reactive({
  if(input$municipio == "All"){
    mapapg
  }else{
    mapapg[mapapg$municipios == input$municipios,]
  }
})

data2 <- reactive({
  if(input$cultivo == "All"){
    mapapg
  }else{
    mapapg[mapapg$Total == input$cultivo,]
  }
})

data4 <- eventReactive(input$goButton, {
  data3()
})
# Define server logic para fazer o mapa no Shiny
shinyServer(function(input, output, session) {

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
