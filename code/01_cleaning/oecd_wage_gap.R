library(here)
library(tidyverse)

raw <- read_csv(here("data/raw/oecd/wage_gap.csv"), show_col_types = FALSE)

raw |>
  janitor::clean_names() |>
  pull(subject) |>
  unique()
