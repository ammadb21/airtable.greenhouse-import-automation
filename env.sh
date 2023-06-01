#!/bin/bash

# USAGE
# run: ./env.sh
# select the env
# then run: op run --env-file="./.env" <script>

PS3="Which env do you want to set up? [select 1/2/3] "
select option in "staging" "prod" "clear"; do
    case "$option" in
    staging | "staging")
        echo "AIRTABLE_API_TOKEN=op://Internal IT - Automations/airtable_staging/AIRTABLE_API_TOKEN" > .env
        echo "AIRTABLE_HIRING_URL=op://Internal IT - Automations/airtable_staging/AIRTABLE_HIRING_URL" >> .env
        echo "GREENHOUSE_API_TOKEN=op://Internal IT - Automations/greenhouse_prod/GREENHOUSE_API_TOKEN" >> .env
        echo "Env set to staging!"
        break
        ;;
    prod | "prod")
        echo "AIRTABLE_API_TOKEN=op://Internal IT - Automations/airtable_prod/AIRTABLE_API_TOKEN" > .env
        echo "AIRTABLE_HIRING_URL=op://Internal IT - Automations/airtable_prod/AIRTABLE_HIRING_URL" >> .env
        echo "GREENHOUSE_API_TOKEN=op://Internal IT - Automations/greenhouse_prod/GREENHOUSE_API_TOKEN" >> .env
        echo "Env set to prod!"
        break
        ;;
    clear | "clear")
        rm .env
        echo ".env file has been removed!"
        break
        ;;
    *)
        echo "Incorrect option. Quitting"
        break
        ;;
    esac
done