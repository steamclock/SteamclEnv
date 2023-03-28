#!/bin/sh
echo "Writing .env file to root directory"

printf "API_URL=$API_URL=$" >> ./.env
echo "$PWD"
echo "Wrote .env file."

exit 0
