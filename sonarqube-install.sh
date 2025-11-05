#!/bin/bash

# Install SonarQube using Docker
docker run -d --name sonarqube -p 9000:9000 sonarqube:lts-community

echo "SonarQube installed and running on port 9000"
