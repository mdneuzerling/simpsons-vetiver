
# simpsons

This is a barebones repository for training a simple spline model with `tidymodels` and deploying it with `vetiver`. I created this to aid in my development of adding AWS Lambda support to `vetiver`.

The `simpsons_workflow` model is trained by sourcing `R/create-model.R`. Deployment code (a work-in-progress) is available in `deploy.R`. For AWS Lambda deployment, an S3 bucket will be needed.
