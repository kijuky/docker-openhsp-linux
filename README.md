# docker-openhsp-linux

## build

```shell
docker build . -t hsp:3.6
```

## usage

### CUI

#### compile

ホストのファイルを読み取るために、ホストのカレントディレクトリをコンテナの作業ディレクトリにマウントする。

```shell
echo 'mes "hello world"' >> test.hsp
docker run --rm -it -v "$(pwd):/hsp3.6" hsp:3.6 hspcmp -d -i -u test.hsp
```

カレントディレクトリに `test.ax` ができていれば成功。

#### run

作られた `test.ax` を `hsp3cl` ランタイムに読み込ませる。

```shell
docker run --rm -it -v "$(pwd):/hsp3.6" hsp:3.6 hsp3cl test.ax
```

### GUI

#### install

X Window System をインストールする。

```shell
brew install xquartz
startx
```

メニューの「環境設定」＞「セキュリティ」タブから「ネットワーク・クライアントからの接続を許可」をチェックする。

次に、インダイレクトの設定を有効化する。

```shell
defaults write org.xquartz.X11 enable_iglx -bool true
```

macOS を再起動

#### run

```shell
xhost +
docker run --rm -it -v "$(pwd):/hsp3.6" -e DISPLAY=host.docker.internal:0 --ipc=host hsp:3.6
xhost -
```

X Window System でエラーが出る場合、macOSを再起動すると解消することがある。

## publish

### GitHub Packages

writes:packages ができる[アクセストークンを発行](https://github.com/settings/tokens/new)する。

```shell
export GITHUB_TOKEN=アクセストークン
docker tag hsp:3.6 ghcr.io/kiuky/hsp:3.6
echo $GITHUB_TOKEN | docker login ghcr.io -u kijuky --password-stdin
docker push ghcr.io/kijuky/hsp:3.6                            
```

[パッケージ設定](https://github.com/kijuky?tab=packages)を開き、イメージを公開設定にし、パッケージとリポジトリを関連づける。
