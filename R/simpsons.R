library(tidyverse)
library(tidymodels)

simpsons_raw <- readr::read_csv(
  "~/Downloads/SimpsonsData.csv"
)

simpsons <- simpsons_raw %>%
  mutate(
    # Some dates have dots while others don't
    Airdate = gsub("\\.", "", Airdate),
    Airdate = as.Date(Airdate, format = "%d %b %Y"),
  ) %>%
  arrange(Airdate) %>%
  mutate(
    episode_number = row_number()
  ) %>%
  filter(!is.na(Rating)) # Missing rating for S32E01

simpsons %>%
  ggplot(aes(x = episode_number, y = Rating)) +
  geom_point()



plot_model <- function(simpsons_data, model) {
  simpsons %>%
    mutate(., prediction = predict(model, new_data = .)$.pred) %>%
    ggplot() +
    geom_point(aes(x = episode_number, y = Rating), alpha = 0.3) +
    geom_line(aes(x = episode_number, y = prediction), colour = "blue") +
    labs(
      title = "Simpsons IMDB ratings",
      subtitle = paste("Using model: ", deparse(substitute(model))),
      x = "Episode number"
    ) +
    theme_minimal() +
    theme(text = element_text(size = 14))
}

spline_model <- parsnip::mars(num_terms = 4) %>%
  set_mode("regression") %>%
  set_engine("earth") %>%
  fit(Rating ~ episode_number, data = simpsons)

plot_model(simpsons, spline_model)
