library(here)
library(tidyverse)
library(arrow)

# Load Data
raw <- open_dataset(here("data/raw/accident_bike"),
        hive_style = TRUE,
        format = "text", delimiter = ";") |>
      collect()

# Rename & Cleaning
code <- read_csv(here("data/translate/accident_bike.csv"),
                     show_col_types = FALSE)

cleaned <- raw |>
  rename_at(vars(code$spanish), ~code$english) |>
  mutate(
    time = lubridate::dmy_hms(str_c(date, hms)),
    weather = recode_factor(weather,
        "Despejado" = "sunny",
        "Nublado" = "cloud",
        "Lluvia débil" = "soft rain",
        "Lluvia intensa" = "hard rain",
        "LLuvia intensa" = "hard rain",
        "Nevando" = "snow",
        "Granizando" = "hail",
        "Se desconoce" = NULL,
        "NULL" = NULL),
    type_person = recode_factor(type_person,
        "Conductor" = "driver",
        "Pasajero" = "passenger",
        "Peatón" = "pedestrian"),
    gender = recode_factor(gender,
        "Hombre" = "men",
        "Mujer" = "women",
        "Desconocido" = NULL
    ),
    positive_alchol = positive_alchol == "S",
    positive_drug = positive_drug == "S",
    )

cleaned |>
  write_parquet(here("data/cleaned/accident_bike.parquet"))
