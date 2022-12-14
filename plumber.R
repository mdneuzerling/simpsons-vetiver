# Generated by the vetiver package; edit with care

library(pins)
library(plumber)
library(rapidoc)
library(vetiver)

# Packages needed to generate model predictions
if (FALSE) {
    library(earth)
    library(parsnip)
    library(workflows)
}
b <- board_s3(bucket = "mdneuzerling")
v <- vetiver_pin_read(b, "simpsons", version = "20220813T015207Z-b6960")

#* @plumber
function(pr) {
    pr %>% vetiver_api(v)
}
