#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for lightningd"

  set -- lightningd "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "lightningd" ]; then
  mkdir -p "$CLIGHTNING_DATA"
  chmod 777 "$CLIGHTNING_DATA"
  chown -R clightning4j "$CLIGHTNING_DATA"

  echo "$0: setting data directory to $CLIGHTNING_DATA"

  set -- "$@" -datadir="$CLIGHTNING_DATA"
fi

if [ "$1" = "lightningd" ] || [ "$1" = "lightning-cli" ] ; then
  echo
  exec gosu clightning4j "$@"
fi

echo
exec "$@"
