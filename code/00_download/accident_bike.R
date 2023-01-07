library(here)
library(arrow)

url_base <- "https://datos.madrid.es/egob/catalogo/300228-%s-accidentes-trafico-detalle.csv"

years <- c(2019:2022)
keys <- c(19, 21, 22, 24) #URL becomes caos since 2020

for (i in seq_along(years)) {
    year <- years[i]
    key <- keys[i]

    url <- sprintf(url_base, key)
    dir_file <- here(sprintf("data/raw/accident_bike/txt/year=%s/", year))
    if (!dir.exists(dir_file)) {
        dir.create(dir_file)
        download.file(url, destfile = paste0(dir_file, "file.txt"))
    }
}


# Export as Parquet
raw <- open_dataset(here("data/raw/accident_bike/txt"),
        hive_style = TRUE,
        format = "text", delimiter = ";")

write_dataset(raw,
    path = here("data/raw/accident_bike/parquet"),
    partitioning = "year")
