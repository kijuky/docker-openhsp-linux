FROM amazonlinux:2 AS build

# 環境変数
ARG HSP_VERSION
ENV HSP_VERSION=${HSP_VERSION:-3.7beta10}

# 必要なソフトをインストール
RUN yum groupinstall -y "Development Tools" && \
    amazon-linux-extras enable epel && \
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

# ソースコードをコンパイル（GPIODは使わない）
RUN curl -L https://github.com/onitama/OpenHSP/archive/refs/tags/v$HSP_VERSION.tar.gz | tar zx -C .
RUN sed -i '/^\s*#define\s\+USE_GPIOD\s*$/d' OpenHSP-$HSP_VERSION/src/hsp3/linux/devctrl_io.cpp
RUN sed -i '/\.word_delay_usecs/d' OpenHSP-$HSP_VERSION/src/hsp3/linux/devctrl_io.cpp
RUN sed -i 's/-lgpiod/-ldl/g' OpenHSP-$HSP_VERSION/makefile
RUN make -C OpenHSP-$HSP_VERSION hsp3cl

FROM public.ecr.aws/lambda/provided:al2 AS runtime

# 環境変数
ARG HSP_VERSION
ENV HSP_VERSION=${HSP_VERSION:-3.7beta10}

COPY --from=build /OpenHSP-$HSP_VERSION/hsp3cl /bin
COPY bootstrap /var/runtime/bootstrap
RUN chmod +x /var/runtime/bootstrap

CMD ["start.ax"]
