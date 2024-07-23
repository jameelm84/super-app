#!/bin/bash

# בדוק אם התיקייה קיימת לפני שאתה מנסה לגשת אליה
if [ -d "/var/www/html/" ]; then
  cd /var/www/html/
else
  echo "/var/www/html/ does not exist"
  exit 1
fi

# בדוק אם הקובץ קיים לפני שאתה מנסה להשתמש בו
if [ -f "./docker-compose.yaml" ]; then
  docker-compose down
else
  echo "docker-compose.yaml does not exist in /var/www/html/"
  exit 1
fi
