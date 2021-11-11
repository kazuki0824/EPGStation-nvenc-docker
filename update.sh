#!/bin/sh

git pull
curl -O https://raw.githubusercontent.com/kazuki0824/EPGStation-nvenc-docker/main/docker-compose.yml
curl -o epgstation/custom.Dockerfile https://raw.githubusercontent.com/kazuki0824/EPGStation-nvenc-docker/main/epgstation-nvenc/Dockerfile
curl -o epgstation/config/config.yml https://raw.githubusercontent.com/kazuki0824/EPGStation-nvenc-docker/main/epgstation-nvenc/config/config.yml.template
