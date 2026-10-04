#!/bin/sh
# Genera config.json desde env vars y arranca el bridge Tuya LAN
# devices.conf se monta en /app/devices.conf desde config/tuya/devices.json
set -e

cat > /app/config.json <<EOF
{
  "host": "${MQTT_HOST}",
  "port": ${MQTT_PORT:-1883},
  "topic": "tuya/",
  "mqtt_user": "${MQTT_USERNAME}",
  "mqtt_pass": "${MQTT_PASSWORD}"
}
EOF

exec node tuya-mqtt.js
