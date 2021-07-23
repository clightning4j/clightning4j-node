FROM ubuntu:20.04
LABEL maintainer="Vincenzo Palazzo (@vincenzopalazzo) vincenzopalazzodev@gmail.com"

RUN useradd -r clightning4j

ENV TZ=Europe/Minsk
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Ubuntu utils
RUN apt-get update && \ 
    apt-get install -y software-properties-common git wget libpq-dev libsodium-dev

## Install jdk 11
RUN add-apt-repository -y ppa:linuxuprising/java
RUN apt-get update  && apt-get install openjdk-11-jdk -y

WORKDIR /home/clightning4j

ENV CLIGHTNING_VERSION=0.10.0
ENV CLIGHTNING_DATA=/home/clightning4j/.lightning

RUN mkdir build && cd build && \
    wget https://github.com/ElementsProject/lightning/releases/download/v${CLIGHTNING_VERSION}/clightning-v${CLIGHTNING_VERSION}-Ubuntu-20.04.tar.xz && \
    tar -xvf clightning-v${CLIGHTNING_VERSION}-Ubuntu-20.04.tar.xz && \
    mv usr clightning-v${CLIGHTNING_VERSION} && \
    mv clightning-v${CLIGHTNING_VERSION} ../

RUN git clone https://github.com/clightning4j/btcli4j.git && cd btcli4j && \
    ./gradlew createRunnableScript

RUN ls -l && cd clightning-v${CLIGHTNING_VERSION} && ls -l

RUN mkdir /home/clightning4j/.lightning

COPY config/config /home/clightning4j/.lightning

ENV PATH="/home/clightning4j/clightning-v${CLIGHTNING_VERSION}/bin:${PATH}"

COPY entrypoint.sh /entrypoint.sh

VOLUME ["/home/clightning4j/.lightning"]

ENTRYPOINT ["/entrypoint.sh"]

RUN echo $(lightningd --version)
RUN apt install -y gosu

CMD ["lightningd"]
# TODO adding plugin https://github.com/clightning4j/lightning-rest

