#!/bin/sh
echo $PWD

set -e

tor -f /opt/torrc --runasdaemon 1 --quiet

curl --socks5 localhost:9050 --socks5-hostname localhost:9050 -s https://check.torproject.org/ | cat | grep -m 1 Congratulations | xargs

chown -R clightning4j /home/clightning4j/.tor
chown -R clightning4j /opt

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for lightningd"
  set -- lightningd --lightning-dir="$CLIGHTNING_DATA" "$@"
fi

# Skip this whole section if $CLIGHTNING_DATA
# (as defined in Dockerfile ENV) already exists
test -d "$CLIGHTNING_DATA" || {
if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "lightningd" ]; then
  mkdir "$CLIGHTNING_DATA"
  cp /opt/config "$CLIGHTNING_DATA/"
  chown -R clightning4j "$CLIGHTNING_DATA"

  echo "$0: setting data directory to $CLIGHTNING_DATA"
fi
}

if [ "$1" = "lightningd" ] || [ "$1" = "lightning-cli" ] ; then
  exec su-exec clightning4j "$@"
fi

echo
exec "$@"