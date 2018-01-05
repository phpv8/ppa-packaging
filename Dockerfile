FROM ubuntu:xenial

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

ARG V8=6.5

RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" > /etc/apt/sources.list.d/ondrej-php-xenial.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C && \
    echo "deb http://ppa.launchpad.net/pinepain/libv8-${V8}/ubuntu xenial main" > /etc/apt/sources.list.d/pinepain-libv8-xenial.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40ECBCF960C60AA4 && \
    apt-get update -q && \
    apt-get install -q -y cdbs devscripts dh-buildinfo pkg-config libglib2.0-dev php-all-dev dh-php libv8-${V8}-dev git vim && \
    sed -i "s/progress_indicator\s*=\s*2/progress_indicator = 0/" /etc/dput.cf && \
    mkdir /root/packaging

WORKDIR /root/packaging
