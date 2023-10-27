library(GetBCBData)
library(plotly)
library(tidyverse)

dadosBNDES <- GetBCBData::gbcbd_get_series(
  id = c("BNDES" = 7415, "Banco" = 20540),
  first.date = "2007-03-01",
  last.date = Sys.Date(),
  format.data = "wide")

graph <- plot_ly(dadosBNDES, type = "scatter", mode = "lines", width = 1000) %>%
  add_trace(x = ~ref.date, y = ~BNDES, name = "BNDES") %>%
  add_trace(x = ~ref.date, y = ~Banco, name = "Bancos Privados") %>%
  layout(title = dadosBNDES$BNDES, legend=list(title=list(text="Variáveis")),
         ticklabelmode="period")
options(warn = -1)

graph <- graph %>%
  layout(
    xaxis = list(zerolinecolor = '#ffff',
                 zerolinewidth = 2,
                 gridcolor = 'ffff'),
    yaxis = list(zerolinecolor = '#ffff',
                 zerolinewidth = 2,
                 gridcolor = 'ffff'),
    plot_bgcolor='#e5ecf6')       

graph
