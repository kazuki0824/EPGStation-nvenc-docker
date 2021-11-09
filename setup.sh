#!/bin/sh

git clone https://github.com/kazuki0824/EPGStation-nvenc-docker.git
INSTALLDIR=$PWD/EPGStation-nvenc-docker

cd /tmp
git clone https://github.com/l3tnun/docker-mirakurun-epgstation.git
cd docker-mirakurun-epgstation
rm -rf ./.gi*
cp -r ./epgstation $INSTALLDIR/.epgstation -n
cp ./docker-compose-sample.yml $INSTALLDIR/docker-compose-no-nvenc.yml
cd ..
rm -rf docker-mirakurun-epgstation

cd $INSTALLDIR
cp .epgstation/config/enc.js.template epgstation-nvenc/config/enc.js
cp epgstation-nvenc/config/config.yml.template epgstation-nvenc/config/config.yml
cp .epgstation/config/operatorLogConfig.sample.yml epgstation-nvenc/config/operatorLogConfig.yml
cp .epgstation/config/epgUpdaterLogConfig.sample.yml epgstation-nvenc/config/epgUpdaterLogConfig.yml
cp .epgstation/config/serviceLogConfig.sample.yml epgstation-nvenc/config/serviceLogConfig.yml
docker-compose run --rm -e SETUP=true mirakurun
