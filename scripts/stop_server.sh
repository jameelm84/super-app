#!/bin/bash
# Print current working directory
echo "Current directory: $(pwd)"
# Stop the application
cd /var/www/html/
docker-compose down
