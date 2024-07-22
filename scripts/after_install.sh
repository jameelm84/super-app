#!/bin/bash
# Print current working directory
echo "Current directory: $(pwd)"
# Copy files to the target directory
cp -r /home/ec2-user/super-app/* /var/www/html/
