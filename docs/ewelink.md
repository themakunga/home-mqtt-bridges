# eWeLink / Sonoff

## Prerrequisitos

- Cuenta eWeLink activa con los dispositivos ya vinculados
- Dispositivos Sonoff con firmware **original** (no Tasmota)

## ⚠️ Limitación de sesión única

eWeLink **solo permite una sesión activa** por cuenta a la vez.

Mientras `ewelink-mqtt` esté corriendo:
- La app móvil eWeLink mostrará "sesión expirada" o quedará desconectada
- Para controlar un dispositivo desde la app, detener el bridge temporalmente

Si necesitas ambos simultáneamente, considera una cuenta eWeLink dedicada para el bridge.

## Variables de entorno

| Variable | Descripción |
|----------|-------------|
| `EWELINK_EMAIL` | Email de la cuenta eWeLink |
| `EWELINK_PASSWORD` | Contraseña |

## Arrancar

```bash
docker compose --profile ewelink up -d
docker compose logs -f ewelink-mqtt
```

## Topics MQTT

| Topic | Descripción |
|-------|-------------|
| `/ewelink_status/<device_id>` | Estado actual del dispositivo (JSON) |
| `/ewelink_command/<device_id>` | Enviar comandos al dispositivo |

## Verificar

```bash
mosquitto_sub \
  -h "$MQTT_HOST" \
  -u "$MQTT_USERNAME" \
  -P "$MQTT_PASSWORD" \
  -t '/ewelink_status/#' \
  -v
```

## Control LAN vs. Cloud

El bridge intenta comunicarse por LAN primero (mDNS/Zeroconf).
Si el dispositivo no está en la misma red, cae back a la API cloud de eWeLink.

## Dispositivos compatibles

- Sonoff Basic / R2 / R3
- Sonoff Mini / R2 / R3
- Sonoff Dual / R2 / R3
- Sonoff 4CH / 4CH Pro
- Sonoff TH (temperatura/humedad)
- Sonoff S20 / S26 / S31 (enchufes)
- Cualquier dispositivo con firmware eWeLink original

## Troubleshooting

| Síntoma | Causa | Solución |
|---------|-------|----------|
| Sesión expirada constantemente | App móvil activa en paralelo | Solo puede haber una sesión — detener bridge o cerrar app |
| No encuentra dispositivos LAN | mDNS bloqueado | Verificar `network_mode: host` |
| Error 401 / autenticación | Credenciales incorrectas | Verificar email y contraseña en `.env` |
