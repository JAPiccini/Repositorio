library(yfR)
library(tidyverse)
library(plotly)
library(lubridate)
library(data.table)
library(zoo)

#Ações para serem selecionadas
my_tickers <- c("AMER3.SA")

#Formando o dataframe com ações selecionadas e a data selecionada
data2 <- yf_get (tickers = my_tickers,
                 first_date = Sys.Date() -180,  
                 last_date = Sys.Date())

data_wide <- yf_convert_to_wide(data2)

prices_wide <- data_wide$price_close

#----------------Médias-Móveis-------------------------
MMC <- zoo::rollmeanr(data2$price_close, k = 7, select = ref_date, fill = NA)
MMC <- cbind(MMC)
MML <- zoo::rollmeanr(data2$price_close, k = 21, fill = NA)
MML <- cbind(MML)
data2$MMC <- MMC
data2$MML <- MML

#-----------------------Gráfico 2.0----------------------------
graph <- plot_ly(data2, type = "scatter", mode = "lines", width = 1000) %>%
  add_trace(x = ~ref_date, y = ~price_close, name = "Preço") %>%
  add_trace(x = ~ref_date, y = ~MMC, name = "Média Móvel Curta") %>%
  add_trace(x = ~ref_date, y = ~MML, name = "Média Móvel Longa") %>%
  layout(title = data2$ticker[1], legend=list(title=list(text="Variáveis")),
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
