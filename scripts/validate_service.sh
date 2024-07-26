#!/bin/bash

# בדוק אם כל הקונטיינרים רצים
if ! docker ps | grep -q 'super-app_node-app_1'; then
    echo "Node.js app is not running"
    exit 1
fi

if ! docker ps | grep -q 'super-app_php-app_1'; then
    echo "PHP app is not running"
    exit 1
fi

if ! docker ps | grep -q 'super-app_mysql_1'; then
    echo "MySQL is not running"
    exit 1
fi

# בדוק אם ה-Node.js שירות זמין
if ! curl -sSf http://localhost:3000 > /dev/null; then
    echo "Node.js service is not responding"
    exit 1
fi

# בדוק אם ה-PHP שירות זמין
if ! curl -sSf http://localhost:80 > /dev/null; then
    echo "PHP service is not responding"
    exit 1
fi

echo "All services are running and responsive"
