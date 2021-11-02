#!/bin/sh

git clone https://github.com/kazuki0824/EPGStation-nvenc-docker.git
INSTALLDIR=$PWD/EPGStation-nvenc-docker

cd /tmp
git clone https://github.com/l3tnun/docker-mirakurun-epgstation.git
cd docker-mirakurun-epgstation
rm -rf ./.gi*
cp -r ./* $INSTALLDIR -n
cd ..
rm -rf docker-mirakurun-epgstation

cd $INSTALLDIR
#cp docker-compose-sample.yml docker-compose.yml
cp epgstation/config/enc.js.template epgstation/config/enc.js
cp epgstation/config/config.yml.template epgstation/config/config.yml
cp epgstation/config/operatorLogConfig.sample.yml epgstation/config/operatorLogConfig.yml
cp epgstation/config/epgUpdaterLogConfig.sample.yml epgstation/config/epgUpdaterLogConfig.yml
cp epgstation/config/serviceLogConfig.sample.yml epgstation/config/serviceLogConfig.yml
