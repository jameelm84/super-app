#!/bin/bash

# Validate the service is running
curl -f http://localhost:3000 || exit 1
