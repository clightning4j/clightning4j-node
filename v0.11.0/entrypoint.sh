#!/bin/sh
set -e
chown -R tor:nogroup /var/lib/tor
#chown -R clightning4j /opt
#chown clightning4j /opt/conf_env.vsh
#chown clightning4j /opt/go-lnmetrics

v run /opt/conf_env.vsh "$@"