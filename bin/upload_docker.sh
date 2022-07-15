#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker.sh`

# Tag image
docker tag flask-app nhothuy48cb/flask-app:1.0
docker tag flask-app nhothuy48cb/flask-app:lastest

# Login to docker-hub
docker login --username=nhothuy48cb

# Push image
docker push nhothuy48cb/flask-app:1.0
docker push nhothuy48cb/flask-app:lastest