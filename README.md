# docker-openhsp-linux

[Linux向けOpenHSP](https://github.com/onitama/OpenHSP)をmacOSで使う。

## 事前準備

dockerをインストール。

https://www.docker.com/get-started/

## イメージの用意

### pull

ビルド済みイメージを利用する場合。

```shell
docker pull ghcr.io/kijuky/hsp:3.7beta10
docker tag ghcr.io/kiuky/hsp:3.7beta10 hsp:3.7beta10 # optional
```

### build

自分でイメージをビルドする場合。

```shell
docker build . -t hsp:3.7beta10
```

## 使用方法

### CUI

#### compile

ホストのファイルを読み取るために、ホストのカレントディレクトリをコンテナの作業ディレクトリにマウントする。

```shell
echo 'mes "hello world"' >> test.hsp
docker run --rm -it -v "$(pwd):/hsp3.7beta10" hsp:3.7beta10 hspcmp -d -i -u test.hsp
```

カレントディレクトリに`test.ax`ができていれば成功。

#### run

作られた`test.ax`を`hsp3cl`ランタイムに読み込ませる。

```shell
docker run --rm -it --privileged -v "$(pwd):/hsp3.7beta10" hsp:3.7beta10 hsp3cl test.ax
```

### GUI

#### install

X Window Systemをインストールする。

```shell
brew install xquartz
startx
```

メニューの「環境設定」＞「セキュリティ」タブから「ネットワーク・クライアントからの接続を許可」をチェックする。

次に、インダイレクトの設定を有効化する。

```shell
defaults write org.xquartz.X11 enable_iglx -bool true
```

macOSを再起動。

#### run

```shell
xhost +
docker run --rm -it -v "$(pwd):/hsp3.7beta10" -e DISPLAY=host.docker.internal:0 --ipc=host hsp:3.7beta10
xhost -
```

X Window Systemでエラーが出る場合、macOSを再起動すると解消することがある。

## (開発者向け)イメージの公開方法

### GitHub Packages

writes:packagesができる[アクセストークンを発行](https://github.com/settings/tokens/new)する。

```shell
export GITHUB_TOKEN=アクセストークン
echo $GITHUB_TOKEN | docker login ghcr.io -u kijuky --password-stdin
docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/kijuky/hsp:3.7beta10 --push .
```

[パッケージ設定](https://github.com/kijuky?tab=packages)を開き、イメージを公開設定にし、パッケージとリポジトリを関連づける。
