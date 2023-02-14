library(httr)
library(jsonlite)

ibge <- GET("https://servicodados.ibge.gov.br/api/v1/localidades/estados/33|35|41|42|43|50|11|12|13|14|15|16|17|21|24|25|26|27|28|29|31|51|52|53|22|23|32/municipios")
ibge <- fromJSON(rawToChar(ibge$content), flatten = TRUE)

ibge <- ibge[, -c(2:7)]
ibge <- ibge[, -c(4:16)]
colnames(ibge)[1] ="codigo"
