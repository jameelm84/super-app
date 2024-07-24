#!/bin/bash

# הפעלת הקונטיינרים של docker-compose
cd /var/www/html/ || exit 1

if [ -f "docker-compose.yaml" ]; then
  docker-compose up -d
else
  echo "docker-compose.yaml not found in /var/www/html/"
  exit 1
fi
