library(GetBCBData)
library(plotly)
library(tidyverse)

dadosBNDES <- GetBCBData::gbcbd_get_series(
  id = c("BNDES" = 7415, "Banco_PJ" = 20540),
  first.date = "2007-03-01",
  last.date = Sys.Date(),
  format.data = "wide")

gráfico_BNDES <- plot_ly(dadosBNDES, x = ~ref.date, y = ~BNDES, type = "scatter", mode = "lines")

ab <- list(
  tickfont = list(color = "greys"),
  overlaying = "y",
  side = "right",
  title = "Saldo Carteira Bancos PJ")

gráfico_BNDES <- gráfico_BNDES %>% 
  add_trace(x = ~ref.date, y = ~Banco_PJ, name = "Crédito PJ", yaxis = "y2", mode = "lines+markers", type = "scatter")

gráfico_BNDES <- gráfico_BNDES %>% 
  layout(
    title = "Relação Carteira de Crédito Bancos Privados p/ PJ e BNDES", yaxis2 = ab,
    yaxis = list(title="Saldo Carteira BNDES"))%>%
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

gráfico_BNDES

