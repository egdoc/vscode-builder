FROM ubuntu:18.04
LABEL maintainer="egdoc.dev@gmail.com"
RUN apt-get update && apt-get install -y \
  git \
  python \
  make \
  gcc \
  libx11-dev \
  libxkbfile-dev \
  libsecret-1-dev \
  fakeroot \
  rpm \
  npm \
  curl

RUN npm install -g yarn
RUN npm cache clean -f && npm install -g n && n 10.15.1
RUN useradd -m compiler --shell /bin/bash && mkdir /home/compiler/src
RUN chown 1000:1000 /home/compiler/src
