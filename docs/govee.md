# Govee

## Prerrequisitos

### 1. Activar LAN Control

En la app Govee (móvil):
- Dispositivo → **Más (⋮)** → **Control LAN**

Solo los dispositivos con LAN Control habilitado aparecerán en el bridge.

### 2. API Key (opcional)

La API Key amplía el descubrimiento de dispositivos. Sin ella el bridge igual funciona
usando solo LAN y las credenciales de cuenta.

Para solicitarla: **Perfil → About Us → Apply for API Key**

## Variables de entorno

| Variable | Requerida | Descripción |
|----------|-----------|-------------|
| `GOVEE_EMAIL` | Sí | Email de la cuenta Govee |
| `GOVEE_PASSWORD` | Sí | Contraseña |
| `GOVEE_API_KEY` | No | API Key (dejar vacío si no se tiene) |

> El bridge también usa las variables `MQTT_*` comunes definidas en `.env`.
> Internamente las mapea a `GOVEE_MQTT_HOST`, `GOVEE_MQTT_PORT`, etc.

## Arrancar

```bash
docker compose --profile govee up -d
docker compose logs -f govee2mqtt
```

## Comprobar descubrimiento

```bash
mosquitto_sub \
  -h "$MQTT_HOST" \
  -u "$MQTT_USERNAME" \
  -P "$MQTT_PASSWORD" \
  -t 'govee/#' \
  -v
```

## Home Assistant Discovery

govee2mqtt publica automáticamente en `homeassistant/#`. Los dispositivos
aparecerán en HA sin configuración adicional si MQTT Discovery está habilitado.

## Troubleshooting

| Síntoma | Causa | Solución |
|---------|-------|----------|
| No descubre dispositivos | LAN Control deshabilitado | Activar en la app para cada dispositivo |
| Credenciales inválidas | Email o contraseña incorrecto | Verificar login en la app Govee |
| Sin mensajes en `govee/#` | `MQTT_HOST` incorrecto | Verificar IP del broker en `.env` |
| Dispositivo aparece offline | La luz está apagada físicamente | Normal — no es error del bridge |
