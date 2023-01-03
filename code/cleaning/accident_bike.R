library(here)
library(tidyverse)
library(lubridate)

#-----------------------
# Load Data
#-----------------------

# 2010-2018
raw1018 <- tibble()
for (year in 2010:2018) {
    raw <- read_delim(
        here(sprintf("data/raw/accident_bike/%s.csv", year)),
        delim = ";",
        locale = locale(encoding = "windows-1252"),
        show_col_types = FALSE)

    raw1018 <- bind_rows(raw1018, raw)
}

# 2019-2022
raw1922 <- tibble()
for (year in 2019:2022) {
    raw <- read_delim(
        here(sprintf("data/raw/accident_bike/%s.csv", year)),
        delim = ";",
        show_col_types = FALSE)

    raw1922 <- bind_rows(raw1922, raw)
}

#--------------------------
# Rename
#--------------------------

code1018 <- read_csv(here("data/translate/accident_bike/1018.csv"),
                     show_col_types = FALSE)
code1922 <- read_csv(here("data/translate/accident_bike/1922.csv"),
                     show_col_types = FALSE)

tmp <- raw1018 |>
  rename_at(vars(code1018$spanish), ~code1018$english) |>
  head(1000)

cleaned1922 <- raw1922 |>
  rename_at(vars(code1922$spanish), ~code1922$english) |>
  mutate(
    time = dmy_hms(str_c(date, hms)),
    weather = recode_factor(weather,
        "Despejado" = "sunny",
        "Nublado" = "cloud",
        "LLuvia débil" = "soft rain",
        "LLuvia intensa" = "hard rain",
        "Nevando" = "snow",
        "Granizando" = "hail"),
    type_person = recode_factor(type_person,
        "Conductor" = "driver",
        "Pasajero" = "passenger",
        "Peatón" = "pedestrian"),
    gender = recode_factor(gender,
        "Hombre" = "men",
        "Mujer" = "women"
    ),
    positive_alchol = positive_alchol == "S",
    positive_drug = positive_drug == "S",
    )


tmp |>
  mutate(
type_person = recode_factor(type_person,
        "Conductor" = "driver",
        "Pasajero" = "passenger",
        "Peatón" = "pedestrian"),
    gender = recode_factor(gender,
        "HOMBRE" = "men",
        "M" = "women"
    ),
  )

raw1018 |>
  rename_at(vars(code1018$spanish), ~code1018$english) |>
  pull(type_person) |>
  unique()
