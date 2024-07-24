#!/bin/bash

# בדיקת סטטוס של השירות
service_status=$(docker-compose ps -q | xargs docker inspect -f '{{ .State.Status }}' | grep -v "running")
if [ -z "$service_status" ]; then
  echo "All services are running."
else
  echo "Some services are not running."
  exit 1
fi
