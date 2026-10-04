# Troubleshooting

## Diagnóstico rápido

```bash
# Ver logs de todos los bridges activos
./scripts/logs.sh

# Ver logs de un bridge específico
./scripts/logs.sh govee2mqtt
./scripts/logs.sh ewelink-mqtt
./scripts/logs.sh tuya-mqtt

# Validar variables de entorno
./scripts/check-env.sh
```

---

## Problemas generales

### El contenedor no arranca

```bash
docker compose --profile <perfil> up
# Sin -d para ver el error en tiempo real
```

### Variables de entorno faltantes

```bash
cp .env.example .env
# Editar .env con los valores reales
./scripts/check-env.sh
```

### Error "network_mode: host no soportado"

En macOS, `network_mode: host` no funciona de la misma forma que en Linux.
Para desarrollo en Mac, usar la IP del host de Docker Desktop en `MQTT_HOST`
y configurar port mappings manuales si es necesario.

En producción (ZimaOS / CasaOS / Linux), funciona correctamente.

---

## govee2mqtt

| Síntoma | Causa probable | Solución |
|---------|---------------|----------|
| No descubre dispositivos | LAN Control deshabilitado en la app | Activar: dispositivo → Más → Control LAN |
| Credenciales rechazadas | Email o contraseña incorrecto | Verificar en la app Govee |
| Sin mensajes en `govee/#` | `MQTT_HOST` incorrecto | Verificar IP del broker en `.env` |
| Dispositivo aparece offline | La luz está apagada | Normal — el bridge reporta el estado real |

---

## ewelink-mqtt

| Síntoma | Causa probable | Solución |
|---------|---------------|----------|
| Sesión expirada constantemente | App móvil activa en paralelo | Solo una sesión activa por cuenta — cerrar app o crear cuenta dedicada |
| No encuentra dispositivos LAN | mDNS bloqueado | Verificar `network_mode: host` |
| Error 401 | Credenciales incorrectas | Verificar `EWELINK_EMAIL` y `EWELINK_PASSWORD` |
| Bridge se reinicia en loop | Dependencias faltantes al buildear | `docker compose --profile ewelink build --no-cache` |

---

## tuya-mqtt

| Síntoma | Causa probable | Solución |
|---------|---------------|----------|
| Dispositivo no responde | IP incorrecta o cambiante | Asignar IP estática en el router para cada dispositivo |
| `local_key` inválido | Clave rotada al re-vincular en app | Repetir `tuya-cli wizard` y actualizar `devices.json` |
| Versión de protocolo incorrecta | Firmware no reconocido | Probar `3.1`, `3.3` o `3.4` en `devices.json` |
| `devices.json` no encontrado | Archivo no existe | `cp config/tuya/devices.example.json config/tuya/devices.json` |
| Timeout de conexión | Puerto 6668 bloqueado | Verificar que el dispositivo Tuya sea accesible desde el servidor |

---

## Red / MQTT

| Síntoma | Causa probable | Solución |
|---------|---------------|----------|
| "Connection refused" al broker | IP o puerto incorrecto | `ping $MQTT_HOST` y verificar que el puerto 1883 esté abierto |
| "Not authorized" | Credenciales MQTT incorrectas | Verificar `MQTT_USERNAME` y `MQTT_PASSWORD` |
| Sin entidades en Home Assistant | MQTT Discovery deshabilitado | HA → Configuración → Integraciones → MQTT → Opciones → Habilitar discovery |

---

## Rebuild completo

Si algo falla después de cambios en los Dockerfiles:

```bash
docker compose --profile ewelink build --no-cache
docker compose --profile tuya build --no-cache
docker compose --profile govee --profile ewelink --profile tuya up -d
```
