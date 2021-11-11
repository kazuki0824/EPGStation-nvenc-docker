# EPGStation-nvenc-docker
![ci workflow](https://github.com/kazuki0824/EPGStation-nvenc-docker/actions/workflows/docker-publish.yml/badge.svg)
![Docker Stars](https://img.shields.io/docker/stars/kazuki0824/epgstation-nvenc)
![Docker Pulls](https://img.shields.io/docker/pulls/kazuki0824/epgstation-nvenc)

[![dockeri.co](https://dockeri.co/image/kazuki0824/epgstation-nvenc)](https://hub.docker.com/r/kazuki0824/epgstation-nvenc)

[EPGStation](https://github.com/l3tnun/EPGStation)上でnvencを利用できるようにするDockerイメージ  
amd64, arm64で実行可能

## 構成
- [Node.js](https://nodejs.org/ja/download/releases/): ^16.0.0
- [FFmpeg](https://www.ffmpeg.org/download.html): 4.4.1
- CUDA: 11.4.2
- [ffnvcodec](https://github.com/FFmpeg/nv-codec-headers)

## インストール
```sh
curl -sf https://raw.githubusercontent.com/kazuki0824/EPGStation-nvenc-docker/main/setup.sh | sh -s
cd EPGStation-nvenc-docker

#チャンネル設定
nano mirakurun/conf/channels.yml

#コメントアウトされている restart や user の設定を適宜変更する
nano docker-compose.yml

docker-compose up -d
```

## Dockerイメージ単体での使用法
kazuki0824/epgstation-nvencをpullして使用します。
```sh
docker run --name <名前> kazuki0824/epgstation-nvenc:latest --gpus [all|<count>]
```
コンテナ実行時にオプション --gpus を追加してください。Docker 19.03以上が必要です

## 参考：Dockerイメージ単体のビルド
もしも自前でコンテナをビルドしたい場合は、`docker-compose.yml`のimageの個所をコメントアウトしてbuildの個所のコメントを解除して使用します。

## 参考：Docker Compose
また、リポジトリの直下のdocker-compose.ymlにはGPUを使用する設定が入っています。
```yaml
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


また、以下の手順で全体を最新のイメージに更新できます。
```sh
DOCKER_BUILDKIT=1 docker-compose pull
```

## 備考
x264の代わりにnvencを使用してエンコードを行うための設定が
epgstation-nvenc/config/config.yml.template
に格納されており、
イメージの/app/config直下にコピーされています。
