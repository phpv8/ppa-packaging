FROM ubuntu:xenial

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

RUN apt-get update -q && \
    apt-get install -q -y cdbs devscripts dh-buildinfo pkg-config libglib2.0-dev git vim python patchelf libatspi2.0-dev curl moreutils jq && \
    sed -i "s/progress_indicator\s*=\s*2/progress_indicator = 0/" /etc/dput.cf
