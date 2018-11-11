# Configure heroku provider
provider "heroku" {
  email = "${var.email}"
  api_key = "${var.heroku_api_key}"
}

# Create Heroku apps for staging and production
resource "heroku_app" "staging" {
  name = "${var.app_name}-staging"
  region = "us"
}

resource "heroku_app" "production" {
  name = "${var.app_name}-production"
  region = "us"
}

# Create a Heroku pipeline
resource "heroku_pipeline" "app_pipeline" {
  name = "${var.app_name}"
}

# Couple apps to different pipeline stages
resource "heroku_pipeline_coupling" "staging" {
  app      = "${heroku_app.staging.name}"
  pipeline = "${heroku_pipeline.app_pipeline.id}"
  stage    = "staging"
}

resource "heroku_pipeline_coupling" "production" {
  app      = "${heroku_app.production.name}"
  pipeline = "${heroku_pipeline.app_pipeline.id}"
  stage    = "production"
}

# Create databases for apps
resource "heroku_addon" "prod_db" {
	app    = "${heroku_app.production.name}"
	plan   = "heroku-postgresql:hobby-basic"
}

resource "heroku_addon" "staging_db" {
	app    = "${heroku_app.staging.name}"
	plan   = "heroku-postgresql:hobby-basic"
}

# Create scheduler add ons for updating data
resource "heroku_addon" "production_scheduler" {
	app    = "${heroku_app.production.name}"
	plan   = "scheduler:standard"
}

resource "heroku_addon" "staging_scheduler" {
	app    = "${heroku_app.staging.name}"
	plan   = "scheduler:standard"
}
