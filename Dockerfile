FROM ubuntu:22.04

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
RUN curl -L https://github.com/onitama/OpenHSP/archive/refs/tags/v3.6.tar.gz | tar zx -C .
WORKDIR "OpenHSP-3.6"
RUN make

ENV LIBGL_ALWAYS_INDIRECT 1

# /usr/bin にシンボリックリンクを作成
RUN cd /usr/bin; \
    ln -s /OpenHSP-3.6/hsed hsed && \
    ln -s /OpenHSP-3.6/hsp3cl hsp3cl && \
    ln -s /OpenHSP-3.6/hsp3dish hsp3dish && \
    ln -s /OpenHSP-3.6/hsp3gp hsp3gp && \
    ln -s /OpenHSP-3.6/hspcmp hspcmp

# デフォルトはエディタを起動
CMD ["hsed"]
