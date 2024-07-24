#!/bin/bash
# Validation commands to ensure the service is up and running
curl -f http://localhost:3000 || exit 1
