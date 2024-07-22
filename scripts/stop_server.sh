#!/bin/bash

# Print current working directory
echo "Current directory: $(pwd)"

# Verify if the directory exists
if [ -d /var/www/html/ ]; then
    cd /var/www/html/
    echo "Changed to directory: $(pwd)"
else
    echo "Directory /var/www/html/ does not exist."
    exit 1
fi

# Check if docker-compose.yaml exists and run the docker-compose command
if [ -f docker-compose.yaml ]; then
    echo "docker-compose.yaml found, stopping containers..."
    docker-compose down
else
    echo "docker-compose.yaml not found in /var/www/html/"
    exit 1
fi
