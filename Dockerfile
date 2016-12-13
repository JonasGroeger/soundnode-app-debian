FROM ubuntu:xenial

RUN apt-get -y update && apt-get -y --no-install-recommends install \
    bash \
    build-essential \
    curl \
    git \
    imagemagick \
    jq \
    ruby \
    ruby-dev
RUN gem install --no-ri --no-rdoc fpm

# Install NodeJS / NPM
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get -y install nodejs

COPY src /root/src
COPY build-deb /root/
COPY packaging-files /root/packaging-files

RUN mkdir -p /root/dist

WORKDIR /root/src

# Remove MAC and WIN builds
RUN sed -i '/osx64/d;/win32/d;/winIco/d;/macIcns/d' tasks/nwjs.js

RUN npm install --global grunt-cli webpack
RUN npm install --legacy-bundling
RUN grunt build

VOLUME dist:/root/dist

WORKDIR /root
RUN ./build-deb
