# MQTT

## Broker externo

Este repositorio **no incluye** un broker MQTT. Configurar el broker existente en `.env`:

```env
MQTT_HOST=192.168.1.10
MQTT_PORT=1883
MQTT_USERNAME=homeassistant
MQTT_PASSWORD=tu_password
```

## Topics por bridge

| Bridge | Prefijo | Descripción |
|--------|---------|-------------|
| Govee | `govee/#` | Luces, sensores Govee |
| Sonoff / eWeLink | `/ewelink_status/#` | Estado de dispositivos Sonoff |
| Sonoff / eWeLink | `/ewelink_command/#` | Comandos hacia dispositivos Sonoff |
| Tuya / Nexxt | `tuya/#` | Dispositivos Tuya LAN |
| HA Discovery | `homeassistant/#` | Auto-discovery para Home Assistant |

## MQTT Discovery (Home Assistant)

**govee2mqtt** publica automáticamente en `homeassistant/#`.
Los dispositivos Govee aparecen en HA sin configuración manual.

Para eWeLink y Tuya, configurar manualmente en HA via plataforma MQTT genérica
o esperar a que los bridges agreguen soporte de discovery.

## Comandos de prueba

### Escuchar todo

```bash
mosquitto_sub \
  -h "$MQTT_HOST" \
  -u "$MQTT_USERNAME" \
  -P "$MQTT_PASSWORD" \
  -t '#' \
  -v
```

### Escuchar por bridge

```bash
# Govee
mosquitto_sub -h "$MQTT_HOST" -u "$MQTT_USERNAME" -P "$MQTT_PASSWORD" -t 'govee/#' -v

# Sonoff
mosquitto_sub -h "$MQTT_HOST" -u "$MQTT_USERNAME" -P "$MQTT_PASSWORD" -t '/ewelink_status/#' -v

# Tuya
mosquitto_sub -h "$MQTT_HOST" -u "$MQTT_USERNAME" -P "$MQTT_PASSWORD" -t 'tuya/#' -v
```

### Publicar comando (ejemplo Tuya)

```bash
mosquitto_pub \
  -h "$MQTT_HOST" \
  -u "$MQTT_USERNAME" \
  -P "$MQTT_PASSWORD" \
  -t 'tuya/living_room_bulb/command' \
  -m '{"dps":{"1":true}}'
```

### Publicar comando (ejemplo Sonoff)

```bash
mosquitto_pub \
  -h "$MQTT_HOST" \
  -u "$MQTT_USERNAME" \
  -P "$MQTT_PASSWORD" \
  -t '/ewelink_command/DEVICE_ID' \
  -m '{"switch":"on"}'
```
