FROM openjdk:11

WORKDIR /jdk

RUN git clone https://github.com/clightning4j/btcli4j.git && cd btcli4j && \
    ./gradlew createRunnableScript -Dorg.gradle.daemon=false --no-build-cache && \
    cd .. && \
    git clone https://github.com/clightning4j/lightning-rest.git && cd lightning-rest && \
    ./gradlew createRunnableScript -Dorg.gradle.daemon=false --no-build-cache

FROM golang:1.18.1 as golang_builder

WORKDIR /lnmetrics

RUN git clone https://github.com/LNOpenMetrics/go-lnmetrics.reporter.git && cd go-lnmetrics.reporter && \
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.45.2 && \
    CGO_ENABLED=0 go build -tags netgo -a -v -o go-lnmetrics cmd/go-lnmetrics.reporter/main.go

FROM alpine:3.16.2
LABEL maintainer="Vincenzo Palazzo (@vincenzopalazzo) vincenzopalazzodev@gmail.com"

RUN addgroup -S clightning4jgroup && adduser -S clightning4j -G clightning4jgroup

ENV CLIGHTNING_VERSION=v23.02.1
ENV CLIGHTNING_DATA=/home/clightning4j/.lightning
ENV HOME=/home/clightning4j

WORKDIR /home/clightning4j

RUN apk update && \
    apk add ca-certificates alpine-sdk autoconf automake git libtool \
    gmp-dev sqlite-dev python3 py3-mako net-tools zlib-dev libsodium gettext su-exec \
    py3-pip python3-dev libffi-dev openssl-dev postgresql postgresql-contrib postgresql-dev \
    cmake protobuf-dev bash

RUN git clone https://github.com/ElementsProject/lightning.git --branch=$CLIGHTNING_VERSION && \
    cd lightning && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    source $HOME/.cargo/env && \
    ./configure && git submodule update --init --recursive && \
    pip3 install --upgrade pip && \
    pip3 install mako mistune==0.8.4 mrkd && \
    make -j$(nproc) && make install

COPY --from=0 /jdk/lightning-rest/build/libs/*.jar /opt/
COPY --from=0 /jdk/btcli4j/build/libs/*.jar /opt/
COPY --from=golang_builder /lnmetrics/go-lnmetrics.reporter/go-lnmetrics /opt/go-lnmetrics
COPY config/plugins/*.sh /opt/
COPY config /opt/
COPY torrc /etc/tor/torrc
COPY entrypoint.sh /entrypoint.sh
COPY conf_env.py /opt/

RUN echo $(lightningd --version)

RUN apk update && \
    apk del gmp-dev sqlite-dev py3-mako net-tools zlib-dev libsodium gettext su-exec \
        py3-pip python3-dev libffi-dev openssl-dev postgresql postgresql-dev \
        cmake protobuf-dev && \
    apk add tor torsocks openjdk11-jre && \
    ~/.cargo/bin/rustup self uninstall -y && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/*


VOLUME ["/etc/torrc.d"]
VOLUME ["/var/lib/tor"]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["lightningd"]
