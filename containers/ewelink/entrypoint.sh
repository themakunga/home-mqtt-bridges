#!/bin/sh
# Traduce env vars → CLI args de NickWaterton/eWeLink-mqtt
# -J publica estado como JSON estructurado
set -e

exec python ewelink.py \
  "$EWELINK_EMAIL" \
  "$EWELINK_PASSWORD" \
  -b "$MQTT_HOST" \
  -p "${MQTT_PORT:-1883}" \
  -U "$MQTT_USERNAME" \
  -P "$MQTT_PASSWORD" \
  -J
