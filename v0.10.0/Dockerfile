FROM ubuntu:20.04
LABEL maintainer="Vincenzo Palazzo (@vincenzopalazzo) vincenzopalazzodev@gmail.com"

RUN useradd -r clightning4j

ENV TZ=Europe/Minsk
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Ubuntu utils
RUN apt-get update && \ 
    apt-get install -y software-properties-common git wget gosu \
    libsodium-dev libpq-dev

## Install jdk 11
RUN add-apt-repository -y ppa:linuxuprising/java
RUN apt-get update  && apt-get install openjdk-11-jdk -y

WORKDIR /home/clightning4j

ENV CLIGHTNING_VERSION=0.10.0
ENV CLIGHTNING_DATA=/home/clightning4j/.lightning

RUN wget https://github.com/ElementsProject/lightning/releases/download/v$CLIGHTNING_VERSION/clightning-v$CLIGHTNING_VERSION-Ubuntu-20.04.tar.xz && \
    tar -xvf clightning-v$CLIGHTNING_VERSION-Ubuntu-20.04.tar.xz -C /opt && cd /opt && \
    mv usr clightning-v$CLIGHTNING_VERSION

RUN rm -r clightning-v$CLIGHTNING_VERSION-Ubuntu-20.04.tar.xz 

RUN cd /opt && \
    git clone https://github.com/clightning4j/btcli4j.git && cd btcli4j && \
    git checkout tags/v0.0.2 -b v0.0.2-b && \
    ./gradlew createRunnableScript && \
    cd .. && \
    git clone https://github.com/clightning4j/lightning-rest.git && cd lightning-rest && \
    git checkout tags/v0.0.1 -b v0.0.1-b && \
    ./gradlew createRunnableScript

RUN mkdir "${CLIGHTNING_DATA}"

COPY config/config /opt

ENV PATH=/opt/clightning-v$CLIGHTNING_VERSION/bin:$PATH

COPY entrypoint.sh /entrypoint.sh

VOLUME ["/home/clightning4j"]

ENTRYPOINT ["/entrypoint.sh"]

RUN echo $(lightningd --version)
RUN echo ${CLIGHTNING_DATA}/config

CMD ["lightningd"]