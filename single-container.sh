#!/bin/sh

git clone https://github.com/kazuki0824/EPGStation-nvenc-docker.git --no-checkout

cd EPGStation-nvenc-docker
git sparse-checkout init
git sparse-checkout set epgstation-nvenc
git checkout master

DOCKER_BUILDKIT=1 docker build ./epgstation-nvenc/
