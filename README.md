## Infrastructure setup for a heroku pipeline

- One pipeline
- Two apps (staging & production)
- Two postgresql DBs
- Two schedulers to run update commands 

*REPO does not include a variables file which should be stored locally and included in the .gitignore. Three variables used in this setup are app_name, email and heroku_api_key*

### Commands to run
1. terraform init
2. terraform plan
3. terraform apply