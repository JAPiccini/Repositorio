library(GetBCBData)
library(tidyverse)
library(plotly)

dados <- GetBCBData::gbcbd_get_series(
  id = c("Dólar" = 3698, "Dívida" = 4536),
  first.date = "2006-12-01",
  last.date = Sys.Date(),
  format.data = "wide")

graph <- plot_ly(dados, x = ~ref.date, y = ~Dólar, name = "Dólar", type = "scatter", mode = "lines")
                 

ay <- list(
  tickfont = list(color = "red"),
  overlaying = "y",
  side = "right",
  title = "Dívida Pública")

graph <- graph %>% 
  add_trace(x = ~ref.date, y = ~Dívida, name = "Dívida", yaxis = "y2", mode = "lines", type = "scatter")

graph <- graph %>% 
  layout(
  title = "Relação Dívida-Dólar", yaxis2 = ay,
  xaxis = list(title=""),
  yaxis = list(title="Dólar"))%>%
  layout(plot_bgcolor='#e5ecf6',
         xaxis = list(
           zerolinecolor = '#ffff',
           zerolinewidth = 2,
           gridcolor = 'ffff'),
         yaxis = list(
           zerolinecolor = '#ffff',
           zerolinewidth = 2,
           gridcolor = 'ffff')
  )
graph
