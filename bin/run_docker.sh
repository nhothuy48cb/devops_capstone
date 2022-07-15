#!/usr/bin/env bash

# Run flask-app container
docker run -d -p 80:80 --name flask-app flask-app