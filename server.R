library(shiny)
library(leaflet)
library(htmltools)
library(htmlwidgets)
library(shinydashboard)
library(RColorBrewer)
library(colorspace)


# Define server logic para fazer o mapa no Shiny
server <- function(input, output, session) {

  # Reactive dataset
  newData <- reactive({

    input$go
    isolate({

      mapapg3 <- subset(mapapg3, municipios == input$STORE_NAME)

    })

    return(mapapg3)

  })

output$map <- renderLeaflet({
  mapapg3 = newData()
    pal <- colorBin(palette = "Greens", domain = mapapg3@data$Total , na.color="transparent")

    state_popup <- paste0("<strong>Município: </strong>",
                          mapapg3$municipios,
                          "<br><strong>Hectares: </strong>",
                          mapapg3$Total)
    leaflet(data = mapapg3) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addPolygons(fillColor = ~pal(mapapg3$Total),
                  fillOpacity = 1.0,
                  color = "#BDBDC3",
                  weight = 1,
                  popup = state_popup) %>%
      addLegend("bottomright", pal = pal, values = ~mapapg3$Total,
                title = "Área Colhida(ha)",
                opacity = 1)
  })


}
shinyApp(ui, server)
