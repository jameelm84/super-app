#!/bin/bash

# Change directory to the deployment directory
cd /var/www/html/ || exit

# Check if docker-compose.yaml exists and run the docker-compose command
if [ -f docker-compose.yaml ]; then
    docker-compose down
else
    echo "docker-compose.yaml not found in /var/www/html/"
    exit 1
fi
