#!/bin/bash

# עצירת הקונטיינרים של docker-compose
cd /var/www/html/ || exit 1

# בדוק אם קובץ docker-compose.yaml קיים לפני הרצת docker-compose down
if [ -f "docker-compose.yaml" ];then
  docker-compose down
else
  echo "docker-compose.yaml not found in /var/www/html/"
  exit 1
fi
