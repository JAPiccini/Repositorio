library(GetBCBData)
library(tidyverse)
library(plotly)

dados <- GetBCBData::gbcbd_get_series(
  id = c("Custo_Crédito" = 25351),
  first.date = "2013-01-01",
  last.date = Sys.Date(),
  format.data = "wide")


graph <- plot_ly(dados, x = ~ref.date, y = ~Custo_Crédito, type = "scatter", mode = "lines")
graph
