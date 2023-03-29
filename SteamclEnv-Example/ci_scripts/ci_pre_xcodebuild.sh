#!/bin/sh
echo "Writing .env file to root directory"

echo "API_URL=$API_URL" >| "./.env"

echo "Wrote .env file. Running steamclenv generate..."

# We're in the ./ci_scripts folder here, so need to step up one level
swift run steamclenv generate --output-path "../"

exit 0
