#!/usr/bin/env bash
set -euo pipefail
# Levanta todos los bridges disponibles
docker compose \
  --profile govee \
  --profile ewelink \
  --profile tuya \
  up -d
