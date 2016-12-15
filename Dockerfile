FROM jonasgroeger/soundnode-app-build-base:latest

COPY src /root/src
COPY build-deb /root/
COPY packaging-files /root/packaging-files

RUN mkdir -p /root/dist

WORKDIR /root/src

# Remove MAC and WIN builds
RUN sed -i '/osx64/d;/win32/d;/winIco/d;/macIcns/d' tasks/nwjs.js

RUN npm install --legacy-bundling
RUN grunt build

WORKDIR /root
RUN ./build-deb
