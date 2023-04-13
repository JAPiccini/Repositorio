library(tidyverse)
library(data.table)

#Setando a minha biblioteca onde estão os arquivos como "Working directory"
setwd("~/Projeto")

#Procedimento padrão para puxar a tabela original
tabela01 <- read_delim("01Tab6957.csv",
                       delim = ";", escape_double = FALSE, locale = locale(decimal_mark = ",",
                       grouping_mark = "."), trim_ws = TRUE,
                       skip = 7)
#Alterando o Cabeçalho
tabela01 <- rename(tabela01, codigo = "Cód.", municipios = 'Brasil e Município')

# Removendo o BR
tabela01 <- tabela01 [-c(1), ]

#Removendo as Linhas Finais
tabela01 <- head(tabela01, -14)

#Removendo o '-' e o 'X'
tabela01 <- tabela01 %>%
  mutate(across(where(is.character()), ~na_if(., 'X')))

tabela01[tabela01=='-'] <- '0'

tabela01 <- tabela01%>%
  mutate(across(!municipios, as.numeric))%>%
  mutate(across(c(codigo,municipios), as.character))

#Removendo o NA
tabela01[is.na(tabela01)] <- 0

#Somando as Linhas
tabela01$Soma_Cidade = rowSums(tabela01[,c(4:57)])

#Realocando a Soma Para o Começo da Tabela
tabela01 <- tabela01 %>%
  relocate(Soma_Cidade, .before = "Abacaxi")

#Somando as Colunas e Removendo as Totais
teste01 <- tabela01 %>%
  summarise_if(is.numeric, sum)
teste01 <- subset(teste01, select = -Total)
teste01 <- subset(teste01, select = -Soma_Cidade)

#Adicionando a Coluna 'Área' para que apareça na tabela transposta
teste01 <- teste01 %>%
  add_column(Cultivo = 'Área',
         .before = 'Abacaxi')

#Transpondo a Tabela
teste01t = setNames(data.frame(t(teste01[,-1])), teste01[,1])

#Organizar a tabela de forma decrescente para descobrir qual produto tem a maior área colhida
setorder(teste01t, cols = -'Área')

#Filtrando a Tabela
tabela02 = data.frame(tabela01[5:58] > 0)

#Somando True
tabela03 = data.frame(colSums(tabela02, na.rm = FALSE, dims = 1))

#Alterando cabeçalho da tabela
colnames(tabela03)[1] = 'Número de cidades que cultivam'

#Ordenando a tabela crescente
tabela03 = setorder(tabela03, cols = 'Número de cidades que cultivam', na.last = TRUE)

#Criando outra tabela para fazer ordem decrescente
tabela03D = data.frame(arrange(tabela03, -`Número de cidades que cultivam`))

#Exportando os dados em formato csv
write.csv(tabela01, 'tabela01.csv', fileEncoding = 'UTF-8')
write.csv(teste01t, 'teste01t.csv', fileEncoding = "UTF-8")
write.csv(tabela03D, 'tabela03D.csv', fileEncoding = "UTF-8")


#tabela01 = tabela original com os dados
#teste01 = tabela01 com a soma dos hectares plantados por cidade
#teste01t = teste01 transposta (vizualização do cultivo com + hectares plantados)
#tabela02 = filtro > 0 da tabela01
#tabela03 = tabela02 somada para saber quais produtos são os mais/menos cultivados
#tabela03_ = tabela03 ordenada do maior para o maior

