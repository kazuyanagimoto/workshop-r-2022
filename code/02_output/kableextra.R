library(here)
library(tidyverse)
library(kableExtra)

data <- arrow::read_parquet(here("data/cleaned/accident_bike.parquet"))

tab <- data |>
  filter(!is.na(weather), !is.na(gender)) |>
  group_by(year, gender, weather) |>
  count() |>
  pivot_wider(names_from = gender, values_from = n, names_prefix = "n_") |>
  pivot_wider(names_from = year, values_from = starts_with("n_"))

options(knitr.kable.NA = '')

ktb <- tab |>
  kbl(booktabs = TRUE, col.names = c(" ", 2019:2022, 2019:2022), format = "latex") |>
  add_header_above(c(" ", "Men" = 4, "Women" = 4)) |>
  pack_rows(index = c("Good" = 2, "Bad" = 4))

ktb |>
  save_kable(here("output/tex/kableextra/tb_accident_bike.tex"))

