FROM ubuntu:xenial

ARG V8=0

ENV DEBIAN_FRONTEND noninteractive
ENV TERM=xterm-256color

RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" > /etc/apt/sources.list.d/ondrej-php-xenial.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C && \
    apt-get update && \
    mkdir /root/packaging

RUN apt-get install -y cdbs devscripts dh-buildinfo pkg-config php-all-dev dh-php git vim

RUN sed -i "s/progress_indicator\s*=\s*2/progress_indicator = 0/" /etc/dput.cf


WORKDIR /root/packaging
