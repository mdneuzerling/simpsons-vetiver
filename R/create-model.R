library(tidyverse)
library(tidymodels)

# We only do this to the training data, so we don't need a recipe here
simpsons <- readr::read_csv(
  "~/Downloads/SimpsonsData.csv"
) %>%
  janitor::clean_names() %>%
  mutate(
    # Some dates have dots while others don't
    airdate = gsub("\\.", "", airdate),
    airdate = as.Date(airdate, format = "%d %b %Y"),
  ) %>%
  arrange(airdate) %>%
  mutate(
    episode_number = row_number()
  ) %>%
  filter(!is.na(rating)) # Missing rating for S32E01

spline_model <- parsnip::mars(num_terms = 4) %>%
  set_mode("regression") %>%
  set_engine("earth")

simpsons_workflow <- fit(
  workflow(rating ~ episode_number, spline_model),
  simpsons
)
