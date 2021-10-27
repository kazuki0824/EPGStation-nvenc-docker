# EPGStation-nvenc-docker
![ci workflow](https://github.com/kazuki0824/EPGStation-nvenc-docker/actions/workflows/docker-publish.yml/badge.svg)
![Docker Stars](https://img.shields.io/docker/stars/kazuki0824/epgstation-nvenc)
![Docker Pulls](https://img.shields.io/docker/pulls/kazuki0824/epgstation-nvenc)

[![dockeri.co](https://dockeri.co/image/kazuki0824/epgstation-nvenc)](https://hub.docker.com/r/kazuki0824/epgstation-nvenc)

[EPGStation](https://github.com/l3tnun/EPGStation)上でnvencを利用できるようにするDockerイメージ  
コンテナ実行時にオプション --gpus [all|<count>]を追加してください。

## 構成
- [node.js](https://nodejs.org/ja/download/releases/): ^16.0.0
- [FFmpeg](https://www.ffmpeg.org/download.html): 4.4.1
- CUDA: 11.4.2
- [ffnvcodec](https://github.com/FFmpeg/nv-codec-headers)

## 参考：Docker Compose
また、リポジトリの直下のdocker-compose.ymlにはGPUを使用する設定が入っています。
```
        deploy:
          resources:
            reservations:
              devices:
              - driver: nvidia
                capabilities: [gpu,video,utility]
```
Mirakurun, MySQLを同時起動する設定になっています.  
（※現時点ではチューナデバイスの操作プログラムが同梱されていません。またrecpt1についてはサポートしません。ご自身で設定できる方のみご使用ください）  
(TODO: [Rust製チューナコントローラ](https://github.com/kazuki0824/b25-kit-rs)をMirakurunコンテナに組み込む)


## 備考
x264の代わりにnvencを使用してエンコードを行うための設定が
config/config.yml.template
に格納されており、  
イメージの/app/config直下にコピーされています。
