#!/bin/bash

# צור את התיקייה /var/www/html אם היא לא קיימת
if [ ! -d "/var/www/html" ]; then
  sudo mkdir -p /var/www/html
fi

# ודא שיש הרשאות גישה ל ec2-user
sudo chown -R ec2-user:ec2-user /var/www/html
