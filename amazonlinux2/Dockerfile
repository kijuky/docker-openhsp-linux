FROM amazonlinux:2

# build GPIOD
RUN yum groupinstall -y "Development Tools" && \
    yum install -y \
    autoconf \
    automake \
    libtool \
    m4 \
    git \
    which \
    autoconf-archive \
    && yum clean all
RUN git clone https://github.com/brgl/libgpiod.git && \
    cd libgpiod && \
    git checkout v1.6.x && \
    mkdir -p m4 && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    ldconfig
RUN cd /lib64; \
    ln -s /usr/local/lib/libgpiod.so.2 libgpiod.so.2

# 環境変数
ARG HSP_VERSION
ENV HSP_VERSION=${HSP_VERSION:-3.7beta10}

# 必要なソフトをインストール
RUN amazon-linux-extras enable epel && \
    yum install -y epel-release && \
    yum install -y \
    gtk2-devel \
    glew-devel \
    SDL2-devel \
    SDL2_image-devel \
    SDL2_mixer-devel \
    SDL2_ttf-devel \
    mesa-libGLES-devel \
    mesa-libEGL-devel \
    libcurl-devel \
    libffi-devel \
    && yum clean all

# ソースコードをコンパイル
RUN curl -L https://github.com/onitama/OpenHSP/archive/refs/tags/v$HSP_VERSION.tar.gz | tar zx -C .
RUN sed -i '/\.word_delay_usecs/d' OpenHSP-$HSP_VERSION/src/hsp3/linux/devctrl_io.cpp
RUN sed -i 's/-lm/-lm -ldl/g' OpenHSP-$HSP_VERSION/makefile
RUN make -C OpenHSP-$HSP_VERSION

# /usr/bin にシンボリックリンクを作成
RUN cd /usr/bin; \
    ln -s /OpenHSP-$HSP_VERSION/hsed hsed && \
    ln -s /OpenHSP-$HSP_VERSION/hsp3cl hsp3cl && \
    ln -s /OpenHSP-$HSP_VERSION/hsp3dish hsp3dish && \
    ln -s /OpenHSP-$HSP_VERSION/hsp3gp hsp3gp && \
    ln -s /OpenHSP-$HSP_VERSION/hspcmp hspcmp

# 作業ディレクトリの作成
RUN mkdir -p /hsp$HSP_VERSION
WORKDIR /hsp$HSP_VERSION

# デフォルトはエディタを起動
CMD ["hsed"]
