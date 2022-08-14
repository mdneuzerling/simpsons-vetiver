# Create the workflow object, `simpsons_workflow`
source("R/create-model.R")

# Load a development version of vetiver.
# Alternatively, replace this with `library(vetiver)`
devtools::load_all("../vetiver-r/")

# Wrap the model with vetiver and test a prediction
simpsons_vetiver <- vetiver_model(simpsons_workflow, "simpsons")
predict(simpsons_vetiver, dplyr::tibble(episode_number = 1000))

# I'm censoring this as it's a public repo
# Whichever S3 bucket you choose, the eventual Lambda IAM role must have access
s3_bucket <- "CENSORED"
s3_board <- pins::board_s3(s3_bucket)
vetiver_pin_write(s3_board, simpsons_vetiver)

simpsons_vetiver$metadata$required_pkgs <- unique(c(
  "knitr",
  simpsons_vetiver$metadata$required_pkgs
))

# Create the `lambdr` `runtime.R` and Dockerfile
vetiver:::vetiver_write_lambda_runtime(s3_board, "simpsons")
vetiver:::vetiver_write_lambda_docker(simpsons_vetiver)
