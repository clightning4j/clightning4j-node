FROM ubuntu:20.04
LABEL maintainer="Vincenzo Palazzo (@vincenzopalazzo) vincenzopalazzodev@gmail.com"

ENV HOME=/home/clightning4j

ENV TZ=Europe/Minsk
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Ubuntu utils
RUN apt-get update && \ 
    apt-get install -y software-properties-common git wget curl gosu \
    libsodium-dev libpq-dev

USER clightning4j
WORKDIR /home/clightning4j

## Install jdk 11
RUN sudo add-apt-repository -y ppa:linuxuprising/java
RUN sudo apt-get update  && sudo apt-get install openjdk-11-jdk -y

ENV CLIGHTNING_VERSION=0.10.1
ENV CLIGHTNING_DATA=/home/clightning4j/.lightning

RUN wget https://github.com/ElementsProject/lightning/releases/download/v$CLIGHTNING_VERSION/clightning-v$CLIGHTNING_VERSION-Ubuntu-20.04.tar.xz && \
    tar -xvf clightning-v$CLIGHTNING_VERSION-Ubuntu-20.04.tar.xz -C $HOME && cd $HOME && \
    mv usr clightning-v$CLIGHTNING_VERSION

RUN rm -r clightning-v$CLIGHTNING_VERSION-Ubuntu-20.04.tar.xz 

RUN git clone https://github.com/clightning4j/btcli4j.git && cd btcli4j && \
    git checkout tags/v0.0.2 -b v0.0.2-b && \
    ./gradlew createRunnableScript && \
    cd .. && \
    git clone https://github.com/clightning4j/lightning-rest.git && cd lightning-rest && \
    git checkout tags/v0.0.2 -b v0.0.2-b && \
    ./gradlew createRunnableScript

RUN mkdir "${CLIGHTNING_DATA}"

COPY config/config $HOME

ENV PATH=/${HOME}/clightning-v$CLIGHTNING_VERSION/bin:$PATH

RUN apt install tor -y

RUN usermod -a -G debian-tor clightning4j

COPY torrc /etc/tor/torrc

COPY entrypoint.sh /entrypoint.sh

RUN rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/archives

RUN chmod 777 -R /home/clightning4j/

VOLUME ["/home/clightning4j"]

ENTRYPOINT ["/entrypoint.sh"]

RUN echo $(lightningd --version)
RUN echo ${CLIGHTNING_DATA}/config

CMD ["lightningd"]