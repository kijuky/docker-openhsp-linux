# docker-openhsp-linux

## build

```shell
docker build -t hsp:3.6
```

## usage

### CUI

#### compile

ホストのファイルを読み取るために、ホストのカレントディレクトリをコンテナのホームディレクトリにマウントし、コンテナのホームディレクトリを作業ディレクトリとする。

```shell
echo 'mes "hello world"' >> test.hsp
docker run --rm -it -v "$(pwd):/root" -w /root hsp:3.6 hspcmp -d -i -u test.hsp
```

カレントディレクトリに `test.ax` ができていれば成功。

#### run

作られた `test.ax` を `hsp3cl` ランタイムに読み込ませる。

```shell
docker run --rm -it -v "$(pwd):/root" -w /root hsp:3.6 hsp3cl test.ax
```

### GUI

#### install

X Window System をインストールする。

```shell
brew install xquartz
startx
```

メニューの「環境設定」＞「セキュリティ」タブから「ネットワーク・クライアントからの接続を許可」をチェックする。

```shell
defaults write org.xquartz.X11 enable_iglx -bool true
```

macOS を再起動

#### run

```shell
xhost +
mkdir -p .local/share
docker run --rm -it -v "$(pwd):/root" -w /root -e DISPLAY=host.docker.internal:0 --ipc=host hsp:3.6
rm -r .local
xhost -
```

X Window System でエラーが出る場合、macOSを再起動すると解消することがある。
