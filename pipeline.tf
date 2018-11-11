# Configure heroku provider
provider "heroku" {
  email = "bchadwick94@gmail.com"
  api_key = "${var.heroku_api_key}"
}

# Create Heroku apps for staging and production
resource "heroku_app" "staging" {
  name = "gas-invest-staging"
}

resource "heroku_app" "production" {
  name = "gas-invest-production"
}

# Create a Heroku pipeline
resource "heroku_pipeline" "gas-invest" {
  name = "gas-invest"
}

# Couple apps to different pipeline stages
resource "heroku_pipeline_coupling" "staging" {
  app      = "${heroku_app.staging.name}"
  pipeline = "${heroku_pipeline.gas-invest.id}"
  stage    = "staging"
}

resource "heroku_pipeline_coupling" "production" {
  app      = "${heroku_app.production.name}"
  pipeline = "${heroku_pipeline.gas-invest.id}"
  stage    = "production"
}

# Create databases for apps
resource "heroku_addon" "database" {
	app    = "${heroku_app.production.name}"
	plan   = "heroku-postgresql:hobby-basic"
}

resource "heroku_addon" "database" {
	app    = "${heroku_app.staging.name}"
	plan   = "heroku-postgresql:hobby-basic"
}

# Create scheduler add ons for updating data
resource "heroku_addon" "production_scheduler" {
	app    = "${heroku_app.production.name}"
	plan   = "heroku-scheduler:standard"
}

resource "heroku_addon" "staging_scheduler" {
	app    = "${heroku_app.staging.name}"
	plan   = "heroku-scheduler:standard"
}
