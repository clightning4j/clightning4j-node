#!/bin/sh
echo $PWD

set -e

tor -f /opt/torrc --runasdaemon 1 --quiet

curl --socks5 localhost:9050 --socks5-hostname localhost:9050 -s https://check.torproject.org/ | cat | grep -m 1 Congratulations | xargs

chown -R clightning4j /home/clightning4j/.tor
chown -R clightning4j /opt
chown clightning4j /home/clightning4j/conf_env.vsh

cd /home/clightning4j
./conf_env.vsh "$@"