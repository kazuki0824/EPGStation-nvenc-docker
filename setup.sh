#!/bin/sh

git clone https://github.com/kazuki0824/EPGStation-nvenc-docker.git
INSTALLDIR=$PWD/EPGStation-nvenc-docker

cd /tmp
git clone https://github.com/l3tnun/docker-mirakurun-epgstation.git
cd docker-mirakurun-epgstation
rm -rf ./.gi*
cp -r ./epgstation $INSTALLDIR/.epgstation -n
cd ..
rm -rf docker-mirakurun-epgstation

cd $INSTALLDIR
#cp docker-compose-sample.yml docker-compose.yml
cp .epgstation/config/enc.js.template epgstation-nvenc/config/enc.js
cp epgstation-nvenc/config/config.yml.template epgstation-nvenc/config/config.yml
cp .epgstation/config/operatorLogConfig.sample.yml epgstation-nvenc/config/operatorLogConfig.yml
cp .epgstation/config/epgUpdaterLogConfig.sample.yml epgstation-nvenc/config/epgUpdaterLogConfig.yml
cp .epgstation/config/serviceLogConfig.sample.yml epgstation-nvenc/config/serviceLogConfig.yml
docker-compose run --rm -e SETUP=true mirakurun
