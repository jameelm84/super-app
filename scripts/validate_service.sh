#!/bin/bash

# בדוק אם הקובץ docker-compose.yaml קיים בנתיב הנכון
if [ -f "/var/www/html/docker-compose.yaml" ]; then
  echo "Validation passed: docker-compose.yaml exists"
else
  echo "Validation failed: docker-compose.yaml does not exist"
  exit 1
fi

# בדוק אם התהליך רץ
if pgrep -f "docker-compose"; then
  echo "Validation passed: docker-compose is running"
else
  echo "Validation failed: docker-compose is not running"
  exit 1
fi
