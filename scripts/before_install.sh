#!/bin/bash

# Print current working directory
echo "Current directory: $(pwd)"

# Create the directory if it doesn't exist
mkdir -p /var/www/html/

# Copy files to the target directory
cp -r /home/ec2-user/super-app/* /var/www/html/

# Verify if the files are copied correctly
echo "Files in /var/www/html/:"
ls -l /var/www/html/
