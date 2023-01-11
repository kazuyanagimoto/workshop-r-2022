library(here)
library(tidyverse)
library(fixest)
library(modelsummary)

data <- arrow::read_parquet(here("data/cleaned/accident_bike.parquet")) |>
  mutate(is_died = injury8 == "Died within 24 hours",
         is_hospitalized = injury8 %in% c("Hospitalization after 24 hours",
                                          "Hospitalization within 24 hours",
                                          "Died within 24 hours"))

models <- list(
    "(1)" = feglm(is_hospitalized ~ type_person + positive_alcohol + positive_drug | age_c + gender,
                family = binomial(logit), data = data),
    "(2)" = feglm(is_hospitalized ~ type_person + positive_alcohol + positive_drug | age_c + gender + type_vehicle,
                family = binomial(logit), data = data),
    "(3)" = feglm(is_hospitalized ~ type_person + positive_alcohol + positive_drug | age_c + gender + type_vehicle + weather,
                family = binomial(logit), data = data),
    "(4)" = feglm(is_died ~ type_person + positive_alcohol + positive_drug | age_c + gender,
                family = binomial(logit), data = data),
    "(5)" = feglm(is_died ~ type_person + positive_alcohol + positive_drug | age_c + gender + type_vehicle,
                family = binomial(logit), data = data),
    "(6)" = feglm(is_died ~ type_person + positive_alcohol + positive_drug | age_c + gender + type_vehicle + weather,
                family = binomial(logit), data = data)
)

cm  <-  c(
    "type_personPassenger" = "Passenger",
    "type_personPedestrian" = "Pedestrian",
    "positive_alcoholTRUE" = "Positive Alcohol"
)

gm <- tibble(
    raw = c("nobs", "FE: age_c", "FE: gender", "FE: type_vehicle", "FE: weather"),
    clean = c("Observations", "FE: Age Group", "FE: Gender", "FE: Type of Vehicle", "FE: Weather"),
    fmt = c(0, 0, 0, 0, 0)
)

modelsummary(models,
  output = "latex_tabular",
  stars = c("+" = .1, "*" = .05, "**" = .01),
  coef_map = cm,
  gof_map = gm) |>
  add_header_above(c(" ", "Hospitalization" = 3, "Died within 24 hours" = 3)) |>
  row_spec(7, hline_after = T) |>
  save_kable(here("output/tex/modelsummary/reg_accident_bike.tex"))
  

