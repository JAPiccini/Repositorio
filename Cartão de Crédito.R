library(GetBCBData)
library(tidyverse)
library(plotly)

dados <- GetBCBData::gbcbd_get_series(
  id = c("Cartão_de_Crédito" = 25149),
  first.date = "2010-12-31",
  last.date = Sys.Date(),
  format.data = "wide")


graph <- plot_ly(dados, x = ~ref.date, y = ~Cartão_de_Crédito, type = "scatter", mode = "lines")
graph
