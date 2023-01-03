url_base <- "https://datos.madrid.es/egob/catalogo/300228-%s-accidentes-trafico-detalle.csv"

years <- c(2010:2022)
keys <- c(10:19, 21, 22, 24) #URL becomes caos since 2020

for (i in seq_along(years)) {
    year <- years[i]
    key <- keys[i]

    url <- sprintf(url_base, key)
    name_file <- here::here(sprintf("data/raw/accident_bike/%s.csv", year))
    if (!file.exists(name_file)) {
        download.file(url, destfile = name_file)
    }
}
