# Tuya / Nexxt

## Prerrequisitos

Los dispositivos Tuya / Nexxt necesitan tres datos para control LAN:
- `id` — identificador del dispositivo
- `ip` — IP local (asignar estática en el router)
- `local_key` — clave de cifrado local

## Obtener id, ip y local_key

Instalar `tuya-cli` (requiere Node.js):

```bash
npm install -g @tuyapi/cli
tuya-cli wizard
```

El wizard pedirá las credenciales de tu cuenta Tuya / Smart Life / Nexxt
y listará todos los dispositivos vinculados con su `id`, `key` (local_key) e `ip`.

> Si los dispositivos están vinculados con la app **Nexxt Home**, usar las mismas
> credenciales — Nexxt usa infraestructura Tuya.

## Configurar devices.json

```bash
cp config/tuya/devices.example.json config/tuya/devices.json
```

Editar `config/tuya/devices.json` con los datos reales:

```json
[
  {
    "id": "xxxxxxxxxxxxxxxxxxxx",
    "name": "living_room_bulb",
    "friendly_name": "Luz Living",
    "ip": "192.168.1.60",
    "local_key": "xxxxxxxxxxxxxxxx",
    "version": "3.3",
    "type": "bulb",
    "enabled": true
  }
]
```

> ⚠️ `devices.json` está en `.gitignore` — **nunca se sube al repositorio**.
> Contiene las `local_key` de tus dispositivos.

## Versiones de protocolo

| Versión | Uso típico |
|---------|-----------|
| `3.1` | Dispositivos antiguos (2018-2019) |
| `3.3` | Mayoría de dispositivos actuales |
| `3.4` | Algunos dispositivos 2022+ |

Si un dispositivo no responde, probar las otras versiones.

## Arrancar

```bash
docker compose --profile tuya up -d
docker compose logs -f tuya-mqtt
```

## Verificar

```bash
mosquitto_sub \
  -h "$MQTT_HOST" \
  -u "$MQTT_USERNAME" \
  -P "$MQTT_PASSWORD" \
  -t 'tuya/#' \
  -v
```

## DPs (Data Points)

Cada dispositivo tiene DPs numerados que representan sus funciones:

| DP | Tipo | Descripción típica |
|----|------|--------------------|
| 1 | bool | On/Off |
| 2 | string | Modo (white/colour/scene) |
| 3 | int | Brillo (0-1000) |
| 4 | int | Temperatura de color (0-1000) |
| 5 | string | Color (HSV hexstring) |

Los DPs varían según el fabricante y modelo. Ver logs del bridge para descubrir los DPs disponibles.

## Troubleshooting

| Síntoma | Causa | Solución |
|---------|-------|----------|
| Dispositivo no responde | IP incorrecta o cambiante | Asignar IP estática en el router (DHCP reservation) |
| `local_key` inválido | Clave rotada al re-vincular el dispositivo | Repetir `tuya-cli wizard` |
| Versión de protocolo incorrecta | Mismatch de firmware | Probar `3.1`, `3.3` o `3.4` |
| `devices.json` no encontrado | Archivo no creado | `cp devices.example.json devices.json` y rellenar |
| Timeout en conexión | Firewall en el dispositivo | Verificar que el puerto 6668 esté accesible en la LAN |
