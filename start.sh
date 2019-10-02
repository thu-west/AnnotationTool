#!/bin/bash
set -e

sudo docker-compose run --rm maven mvn clean compile package
sudo docker-compose run --rm -p 8080:8080 tomcat
