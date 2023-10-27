library(GetDFPData)
library(knitr)
library(GetTDData)

gdfpd.search.company("Petrobras", cache.folder = tempdir())

DF.info <- gdf(type.data = "companies", cache.folder = tempdir())
glimpse(DF.info)

name.companies <- "PETRÓLEO BRASILEIRO S.A. - PETROBRAS"
first.date <- "2010-01-01"
last.date <- Sys.Date()
DF.reports <- gdfpd.GetDFPData(name.companies = name.companies,
                               first.date = first.date,
                               last.date = last.date,
                               cache.folder = tempdir())

glimps(DF.reports)
gdfpd.get.info.companies()
str(DF.info)


yield.curve <- get.yield.curve()
graph <- plot_ly(yield.curve, x = ~current.date, y = ~, "Dólar", type = "scatter", mode = "lines")
