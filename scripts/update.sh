#!/usr/bin/env bash
set -euo pipefail
# Actualiza imágenes y contenedores sin tocar volúmenes ni configuraciones

echo "→ Descargando últimas imágenes..."
docker compose pull

echo "→ Rebuildeando imágenes custom..."
docker compose build --pull

echo "→ Reiniciando servicios..."
docker compose \
  --profile govee \
  --profile ewelink \
  --profile tuya \
  up -d

echo "→ Limpiando imágenes antiguas..."
docker image prune -f

echo "✓ Actualización completada"
