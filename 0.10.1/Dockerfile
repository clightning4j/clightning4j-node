FROM alpine:3.13.6
LABEL maintainer="Vincenzo Palazzo (@vincenzopalazzo) vincenzopalazzodev@gmail.com"

RUN addgroup -S clightning4jgroup && adduser -S clightning4j -G clightning4jgroup

ENV CLIGHTNING_VERSION=0.10.1
ENV CLIGHTNING_DATA=/home/clightning4j/.lightning
ENV HOME=/home/clightning4j

RUN apk update && \
    apk add ca-certificates alpine-sdk autoconf automake git libtool \
    gmp-dev sqlite-dev python3 py3-mako net-tools zlib-dev libsodium gettext su-exec

RUN git clone https://github.com/ElementsProject/lightning.git && \
    cd lightning && git checkout tags/v$CLIGHTNING_VERSION && \
    ./configure && git submodule update --init --recursive && \
    make -j$(nproc) && make install

WORKDIR /home/clightning4j

RUN apk --update --allow-untrusted --repository http://dl-4.alpinelinux.org/alpine/edge/community/ add \
      tor torsocks \
&& apk --update --allow-untrusted --repository http://dl-4.alpinelinux.org/alpine/edge/testing/ add \
      obfs4proxy 

RUN apk add openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community && \ 
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN cd /opt && git clone https://github.com/clightning4j/btcli4j.git && cd btcli4j && \
    # git checkout tags/v0.0.2 -b v0.0.2-b && \
    ./gradlew createRunnableScript -Dorg.gradle.daemon=false --no-build-cache && \
    cd .. && \
    git clone https://github.com/clightning4j/lightning-rest.git && cd lightning-rest && \
    #git checkout tags/v0.0.2 -b v0.0.2-b && \
    ./gradlew createRunnableScript -Dorg.gradle.daemon=false --no-build-cache

RUN apk add --no-cache --upgrade bash

RUN ls -l && echo $PWD
COPY config/* /opt/
COPY torrc /opt
COPY entrypoint.sh /entrypoint.sh

RUN echo $(lightningd --version)

ENTRYPOINT ["/entrypoint.sh"]

CMD ["lightningd"]