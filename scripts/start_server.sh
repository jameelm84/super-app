#!/bin/bash
# Print current working directory
echo "Current directory: $(pwd)"
# Start the application
cd /var/www/html/
docker-compose up -d
