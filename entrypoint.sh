#!/bin/sh
set -e
chown -R tor:nogroup /var/lib/tor
chown root /opt/go-lnmetrics

python3 /opt/conf_env.py "$@"