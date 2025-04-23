#!/bin/bash

source ~/midterm/.env
CHECK_URL="http://localhost:${PORT}/health"
LOG_FILE="$DEPLOY_PATH/health-check.log"

MAX_RETRIES=3
RETRY_INTERVAL=10

attempt=1

while [ $attempt -le $MAX_RETRIES ]; do
  response=$(curl --silent --write-out "%{http_code}" --output /dev/null "$CHECK_URL")

  if [ "$response" -eq 200 ]; then
    echo "$(date): Health check PASSED (200 OK) on attempt $attempt" >> "$LOG_FILE"
    exit 0
  else
    echo "$(date): Health check FAILED ($response) on attempt $attempt" >> "$LOG_FILE"
  fi

  if [ $attempt -lt $MAX_RETRIES ]; then
    sleep $RETRY_INTERVAL
  fi

  attempt=$((attempt+1))
done

echo "$(date): Health check FAILED after $MAX_RETRIES attempts" >> "$LOG_FILE"
exit 1
