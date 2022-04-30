#!/bin/sh
set -e
chown -R tor:nogroup /var/lib/tor
chown root /opt/go-lnmetrics

v run /opt/conf_env.vsh "$@"