# EPGStation-nvenc-docker
![ci workflow](https://github.com/kazuki0824/EPGStation-nvenc-docker/actions/workflows/docker-publish.yml/badge.svg)
![Docker Stars](https://img.shields.io/docker/stars/kazuki0824/epgstation-nvenc)
![Docker Pulls](https://img.shields.io/docker/pulls/kazuki0824/epgstation-nvenc)

[![dockeri.co](https://dockeri.co/image/kazuki0824/epgstation-nvenc)](https://hub.docker.com/r/kazuki0824/epgstation-nvenc)

[EPGStation](https://github.com/l3tnun/EPGStation)上でnvencを利用できるようにするDockerイメージ

## 構成
- [node.js](https://nodejs.org/ja/download/releases/): ^16.0.0  
- [FFmpeg](https://www.ffmpeg.org/download.html): 4.4.1  
- CUDA: 11.4.2  
- [ffnvcodec](https://github.com/FFmpeg/nv-codec-headers)
