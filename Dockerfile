FROM ubuntu:22.04

# 環境変数
ARG HSP_VERSION
ENV HSP_VERSION ${HSP_VERSION:-3.6}

# 必要なソフトをインストール
RUN apt update && apt install -y \
    curl \
    libgtk2.0-dev \
    libglew-dev \
    libsdl1.2-dev \
    libsdl-image1.2-dev \
    libsdl-mixer1.2-dev \
    libsdl-ttf2.0-dev \
    libgles2-mesa-dev \
    libegl1-mesa-dev \
    libsdl2-ttf-dev \
    libsdl2-image-dev \
    libsdl2-mixer-dev \
    && apt clean && rm -rf /var/lib/apt/lists/*

# ソースコードをコンパイル
RUN curl -L https://github.com/onitama/OpenHSP/archive/refs/tags/v$HSP_VERSION.tar.gz | tar zx -C .
RUN make -C OpenHSP-$HSP_VERSION

# /usr/bin にシンボリックリンクを作成
RUN cd /usr/bin; \
    ln -s /OpenHSP-$HSP_VERSION/hsed hsed && \
    ln -s /OpenHSP-$HSP_VERSION/hsp3cl hsp3cl && \
    ln -s /OpenHSP-$HSP_VERSION/hsp3dish hsp3dish && \
    ln -s /OpenHSP-$HSP_VERSION/hsp3gp hsp3gp && \
    ln -s /OpenHSP-$HSP_VERSION/hspcmp hspcmp

# X Window System に対する設定
ENV LIBGL_ALWAYS_INDIRECT 1
RUN mkdir -p ~/.local/share

# 作業ディレクトリの作成（ホームディレクトリはX Window System の設定ファイルが作成されるので、別の場所を指定する）
RUN mkdir -p /hsp$HSP_VERSION
WORKDIR /hsp$HSP_VERSION

# デフォルトはエディタを起動
CMD ["hsed"]
