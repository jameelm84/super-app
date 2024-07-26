#!/bin/bash

# בדיקת תקינות השירותים
cd /home/ec2-user/super-app || exit
docker ps

if ! curl -sSf http://localhost:3000 > /dev/null; then
    echo "Node.js service is not responding"
    exit 1
fi

if ! curl -sSf http://localhost:80 > /dev/null; then
    echo "PHP service is not responding"
    exit 1
fi

echo "All services are running and responsive"
