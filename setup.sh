#!/bin/sh

git clone https://github.com/l3tnun/docker-mirakurun-epgstation.git
cd docker-mirakurun-epgstation
curl -O https://raw.githubusercontent.com/kazuki0824/EPGStation-nvenc-docker/main/docker-compose.yml
curl -o epgstation/custom.Dockerfile https://raw.githubusercontent.com/kazuki0824/EPGStation-nvenc-docker/main/epgstation-nvenc/custom.Dockerfile
curl -o epgstation/config/config.yml https://raw.githubusercontent.com/kazuki0824/EPGStation-nvenc-docker/main/epgstation-nvenc/config/config.yml.template
curl -O https://raw.githubusercontent.com/kazuki0824/EPGStation-nvenc-docker/main/update.sh
docker-compose run --rm -e SETUP=true mirakurun
