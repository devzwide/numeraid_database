#!/bin/bash
# Usage: ./migrate.sh [flyway_command]
# Loads environment variables from .env and runs Flyway with the user service config

set -e

# Load environment variables from .env if it exists
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

cd user_service

# Pass all arguments to flyway (e.g., migrate, info, clean)
flyway -configFiles=flyway_userservice.conf "$@"

