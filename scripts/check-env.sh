#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

errors=0

check_var() {
  local var="$1"
  local val="${!var:-}"
  if [[ -z "$val" ]]; then
    echo -e "${RED}✗ $var está vacío o no definido${NC}"
    ((errors++)) || true
  else
    echo -e "${GREEN}✓ $var${NC}"
  fi
}

echo "─── MQTT (requerido siempre) ──────────────────────────"
check_var MQTT_HOST
check_var MQTT_USERNAME
check_var MQTT_PASSWORD

echo ""
echo "─── Govee (--profile govee) ───────────────────────────"
if [[ -n "${GOVEE_EMAIL:-}" || -n "${GOVEE_PASSWORD:-}" ]]; then
  check_var GOVEE_EMAIL
  check_var GOVEE_PASSWORD
else
  echo -e "${YELLOW}⚠ No configurado (skip)${NC}"
fi

echo ""
echo "─── eWeLink (--profile ewelink) ───────────────────────"
if [[ -n "${EWELINK_EMAIL:-}" || -n "${EWELINK_PASSWORD:-}" ]]; then
  check_var EWELINK_EMAIL
  check_var EWELINK_PASSWORD
else
  echo -e "${YELLOW}⚠ No configurado (skip)${NC}"
fi

echo ""
echo "─── Tuya (--profile tuya) ─────────────────────────────"
DEVICES="$(dirname "$0")/../config/tuya/devices.json"
if [[ -f "$DEVICES" ]]; then
  echo -e "${GREEN}✓ config/tuya/devices.json existe${NC}"
else
  echo -e "${YELLOW}⚠ config/tuya/devices.json no encontrado${NC}"
  echo -e "  → cp config/tuya/devices.example.json config/tuya/devices.json"
fi

echo ""
if [[ "$errors" -gt 0 ]]; then
  echo -e "${RED}$errors variable(s) requerida(s) faltante(s)${NC}"
  exit 1
else
  echo -e "${GREEN}Entorno OK ✓${NC}"
fi
