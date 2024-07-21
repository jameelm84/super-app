#!/bin/bash

# Create the directory if it doesn't exist
mkdir -p /var/www/html/

# Copy files to the target directory
cp -r /home/ec2-user/super-app/* /var/www/html/
