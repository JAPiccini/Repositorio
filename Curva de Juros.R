library(GetTDData)
library(dplyr)
library(plotly)

yield.curve <- get.yield.curve()

yield.curve <- filter(yield.curve, type == "real_return")

graph <- plot_ly(yield.curve, x = ~ref.date, y = ~value, type = "scatter", mode = "lines")
ay <- list(
  tickfont = list(color = "red"),
  overlaying = "y",
  side = "right",
  title = "Curva de Juros")
graph