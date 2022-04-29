FROM openjdk:11

WORKDIR /jdk

RUN git clone https://github.com/clightning4j/btcli4j.git && cd btcli4j && \
    ./gradlew createRunnableScript -Dorg.gradle.daemon=false --no-build-cache && \
    cd .. && \
    git clone https://github.com/clightning4j/lightning-rest.git && cd lightning-rest && \
    ./gradlew createRunnableScript -Dorg.gradle.daemon=false --no-build-cache

FROM golang:1.18.1

WORKDIR /lnmetrics

RUN git clone https://github.com/LNOpenMetrics/go-lnmetrics.reporter.git && cd go-lnmetrics.reporter && \
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.45.2 && \
    make

FROM alpine:3.14.3
LABEL maintainer="Vincenzo Palazzo (@vincenzopalazzo) vincenzopalazzodev@gmail.com"

RUN addgroup -S clightning4jgroup && adduser -S clightning4j -G clightning4jgroup

ENV CLIGHTNING_VERSION=0.11.0
ENV CLIGHTNING_DATA=/home/clightning4j/.lightning
ENV HOME=/home/clightning4j

WORKDIR /home/clightning4j

RUN apk update && \
    apk add ca-certificates alpine-sdk autoconf automake git libtool \
    gmp-dev sqlite-dev python3 py3-mako net-tools zlib-dev libsodium gettext su-exec \
    python3 py3-pip python3-dev libffi-dev openssl-dev postgresql postgresql-contrib postgresql-dev \
    cmake

RUN git clone https://github.com/ElementsProject/lightning.git && \
    cd lightning && \ 
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    source $HOME/.cargo/env && \
    ./configure && git submodule update --init --recursive && \
    pip3 install --upgrade pip && \
    pip3 install --user poetry && \
    #python3 -m poetry config virtualenvs.create false --local && \
    python3 -m poetry install && \
    python3 -m poetry run make -j$(nproc)

RUN cd lightning && python3 -m poetry run make install 

RUN apk --update --allow-untrusted --repository http://dl-4.alpinelinux.org/alpine/edge/community/ add \
      tor torsocks && \
    apk --update --allow-untrusted --repository http://dl-4.alpinelinux.org/alpine/edge/testing/ add \
      obfs4proxy

RUN apk add openjdk11-jre && \ 
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN git clone https://github.com/vlang/v.git && cd v && \
    make && ./v symlink && \
    cd ..

COPY --from=0 /jdk/lightning-rest/build/libs/*.jar /opt/
COPY --from=0 /jdk/btcli4j/build/libs/*.jar /opt/
COPY --from=0 /lnmetrics/go-lnmetrics.reporter/go-lnmetrics /opt/
COPY config/* /opt/
COPY torrc /opt/
COPY entrypoint.sh /entrypoint.sh
COPY conf_env.vsh /home/clightning4j/conf_env.vsh

RUN echo $(lightningd --version)

ENTRYPOINT ["/entrypoint.sh"]

CMD ["lightningd"]