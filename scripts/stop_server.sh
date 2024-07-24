#!/bin/bash

# Create the directory if it does not exist
if [ ! -d "/var/www/html/" ]; then
  sudo mkdir -p /var/www/html/
fi

cd /var/www/html/ || exit 1

# Check if docker-compose.yaml exists before running docker-compose down
if [ -f "docker-compose.yaml" ]; then
  docker-compose down
else
  echo "docker-compose.yaml not found in /var/www/html/"
  exit 1
fi
