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
    time = lubridate::dmy_hms(str_c(date, hms), tz = "Europe/Madrid"),
    district = na_if(district, "NULL"),
    district = str_to_title(district),
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
        "Conductor" = "Driver",
        "Pasajero" = "Passenger",
        "Peatón" = "Pedestrian",
        "NULL"= NULL),
    age_c = recode_factor(age_c,
        "Menor de 5 años" = "<5",
        "De 6 a 9 años" = "6-9",
        "De 10 a 14 años" = "10-14",
        "De 15 a 17 años" = "15-17",
        "De 18 a 20 años" = "18-20",
        "De 21 a 24 años" = "21-24",
        "De 25 a 29 años" = "25-29",
        "De 30 a 34 años" = "30-34",
        "De 35 a 39 años" = "35-39",
        "De 40 a 44 años" = "40-44",
        "De 45 a 49 años" = "45-49",
        "De 50 a 54 años" = "50-54",
        "De 55 a 59 años" = "55-59",
        "De 60 a 64 años" = "60-64",
        "De 65 a 69 años" = "65-69",
        "De 70 a 74 años" = "70-74",
        "Más de 74 años" = ">74",
        "Desconocido" = NULL
    ),
    gender = recode_factor(gender,
        "Hombre" = "Men",
        "Mujer" = "Women",
        "Desconocido" = NULL
    ),
    injury8 = recode_factor(injury8,
        "Sin asistencia sanitaria" = "No health care",
        "Asistencia sanitaria sólo en el lugar del accidente" = "Healthcare only at the place of the accident",
        "Asistencia sanitaria ambulatoria con posterioridad" = "Subsequent outpatient health care",
        "Asistencia sanitaria inmediata en centro de salud o mutua" = "Immediate health care at a health center",
        "Atención en urgencias sin posterior ingreso" = "Emergency care without subsequent hospitalization",
        "Ingreso superior a 24 horas" = "Hospitalization after 24 hours",
        "Ingreso inferior o igual a 24 horas" = "Hospitalization within 24 hours",
        "Fallecido 24 horas" = "Died within 24 hours",
        "Se desconoce" = NULL,
        "NULL" = NULL
    ),
    positive_alcohol = positive_alcohol == "S",
    positive_drug = positive_drug == "S",
    is_died = injury8 == "Died within 24 hours",
    is_hospitalized = injury8 %in% c("Hospitalization after 24 hours",
                                     "Hospitalization within 24 hours",
                                     "Died within 24 hours")
    )

cleaned |>
  write_parquet(here("data/cleaned/accident_bike.parquet"))

