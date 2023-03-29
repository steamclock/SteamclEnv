#!/bin/sh
echo "Writing .env file to root directory"

echo "API_URL=1$API_URL" >| "../.env"

echo "Wrote .env file."

swift run steamclenv generate --path "../.env" --output-path "../"

exit 0
