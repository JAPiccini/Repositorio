library(GetBCBData)
library(plotly)
library(tidyverse)
library(data.table)
library(psych)
library(car)
library(ggpubr)
library(lmtest)
library(writexl)

#Obtendo os dados no BCB
dados <- GetBCBData::gbcbd_get_series(
  id = c("Dólar" = 3698, "Dívida" = 4536, "TC" = 22701),
  first.date = "2010-08-25",
  last.date = Sys.Date(),
  format.data = "wide")

#Análise valores de tendência central
summary(dados$Dólar)
summary(dados$Dívida)
summary(dados$TC)

#Histograma
hist(dados$Dólar)
hist(dados$Dívida)
hist(dados$TC)

#Histograma Interativo
plot_ly(x = dados$Dólar, type = "histogram") %>%
  layout(title = "Histograma Dólar",
         xaxis = list(title = "Cotação",
                      zeroline = FALSE),
         yaxis = list(title = "Frequência",
                      zeroline = FALSE))
plot_ly(x = dados$Dívida, type = "histogram") %>%
   layout(title = "Histograma Dívida",
         xaxis = list(title = "Relação Dívida - PIB(%)",
                      zeroline = FALSE),
         yaxis = list(title = "Frequência",
                      zeroline = FALSE))
plot_ly(x = dados$TC, type = "histogram") %>%
  layout(title = "Histograma Transações Correntes",
         xaxis = list(title = "Saldo Transações Correntes",
                      zeroline = FALSE),
         yaxis = list(title = "Frequência",
                      zeroline = FALSE))

#Teste de normalidade
par(mfrow=c(1,3)) 
qqnorm(dados$Dólar, main='Distribuição Dólar')
qqline(dados$Dólar)
qqnorm(dados$Dívida, main='Distribuição Dívida')
qqline(dados$Dívida)
qqnorm(dados$TC, main='Distribuição Transações Correntes')
qqline(dados$TC)

#Teste de Shapiro Wilk
shapiro.test(dados$Dólar)
shapiro.test(dados$Dívida)
shapiro.test(dados$TC)

#Logaritmizando os dados
dadoslog <- log(data.frame(dados$Dólar, dados$Dívida, dados$TC))

#Gráfico Dólar
graphdo <- plot_ly(dados, type = "scatter", mode = "lines", width = 1000) %>%
    add_trace(x = dados$ref.date, y = dados$Dólar, name = "Dólar") %>%
    add_trace(x = dados$ref.date, y = dadoslog$dados.Dólar, name = "Log Dólar") %>%
  layout(title = "Dólar Linear e Logaritmizado", legend=list(title=list(text="Variáveis")),
         ticklabelmode="period")
options(warn = -1)
graphdo

#Gráfico Dívida
graphdi <- plot_ly(dados, type = "scatter", mode = "lines", width = 1000) %>%
  add_trace(x = dados$ref.date, y = dados$Dívida, name = "Dívida") %>%
  add_trace(x = dados$ref.date, y = dadoslog$dados.Dívida, name = "Log Dívida") %>%
  layout(title = "Dívida Linear e Logaritmizado", legend=list(title=list(text="Variáveis")),
         ticklabelmode="period")
options(warn = -1)
graphdi

#Gráfico Transações Correntes
graphtc <- plot_ly(dados, type = "scatter", mode = "lines", width = 1000) %>%
  add_trace(x = dados$ref.date, y = dados$TC, name = "Transações Correntes") %>%
  add_trace(x = dados$ref.date, y = dadoslog$dados.TC, name = "Log Transações Correntes") %>%
  layout(title = "Transações Correntes Linear e Logaritmizado", legend=list(title=list(text="Variáveis")),
         ticklabelmode="period")
options(warn = -1)
graphtc

#Teste Durbin Watson
durbinWatsonTest(lm(Dólar ~ Dívida, data = dados))

#Regressão
lnBCB <- lm(Dólar ~ Dívida + TC, dados, na.action = na.omit)
summary(lnBCB)

#Exportando os dados
write_xlsx(dados,"Econometria.xlsx", sep = ",")

#Dívida líquida do governo geral (% PIB)
#Transações correntes - mensal - saldo (Milhões de dólares americanos)