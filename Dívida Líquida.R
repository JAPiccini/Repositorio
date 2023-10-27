library(GetBCBData)
library(tidyverse)
library(plotly)

dados <- GetBCBData::gbcbd_get_series(
  id = c("Div.Líq" = 24419),
  first.date = "2000-01-01",
  last.date = Sys.Date(),
  format.data = "wide")


graph <- plot_ly(dados, x = ~ref.date, y = ~Div.Líq, type = "scatter", mode = "lines")
graph
