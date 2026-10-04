#!/usr/bin/env bash
set -euo pipefail
# Uso: ./scripts/logs.sh [servicio]
#
# Ejemplos:
#   ./scripts/logs.sh              # todos los servicios activos
#   ./scripts/logs.sh govee2mqtt   # solo Govee
#   ./scripts/logs.sh ewelink-mqtt
#   ./scripts/logs.sh tuya-mqtt

docker compose logs -f "$@"
