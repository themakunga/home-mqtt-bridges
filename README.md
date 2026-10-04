# home-mqtt-bridges

Bridges MQTT para domótica — conecta dispositivos Govee, Sonoff y Tuya/Nexxt
a un broker MQTT externo (Mosquitto) y Home Assistant.

> **Nota:** Este repositorio **no incluye** Mosquitto ni Home Assistant.
> Ambos servicios corren en otra parte de tu infraestructura.

## Arquitectura

```
Govee ──────────► govee2mqtt ──┐
Sonoff ─────────► ewelink-mqtt ─┼──► MQTT Broker ──► Home Assistant
Tuya / Nexxt ───► tuya-mqtt ───┘
```

Ver [docs/architecture.md](docs/architecture.md) para el diagrama completo.

## Requisitos

- Docker y Docker Compose v2+
- Broker MQTT externo (Mosquitto)
- Credenciales de cada cuenta (Govee, eWeLink, Tuya/Nexxt)

## Instalación rápida

```bash
git clone git@github.com:TheMakunga/home-mqtt-bridges.git
cd home-mqtt-bridges

cp .env.example .env
# Editar .env con tus valores
```

## Configuración

### 1. MQTT (requerido para todos los bridges)

```env
MQTT_HOST=192.168.1.10      # IP de tu broker Mosquitto
MQTT_PORT=1883
MQTT_USERNAME=homeassistant
MQTT_PASSWORD=tu_password
```

### 2. Govee

```env
GOVEE_EMAIL=tu@email.com
GOVEE_PASSWORD=tu_password
GOVEE_API_KEY=               # opcional
```

Activar LAN Control en la app Govee para cada dispositivo. Ver [docs/govee.md](docs/govee.md).

### 3. Sonoff / eWeLink

```env
EWELINK_EMAIL=tu@email.com
EWELINK_PASSWORD=tu_password
```

> ⚠️ Solo puede haber **una sesión activa** por cuenta eWeLink.
> La app móvil quedará desconectada mientras el bridge esté corriendo.

Ver [docs/ewelink.md](docs/ewelink.md).

### 4. Tuya / Nexxt

```bash
# Obtener local_key de cada dispositivo
npm install -g @tuyapi/cli && tuya-cli wizard

# Configurar dispositivos
cp config/tuya/devices.example.json config/tuya/devices.json
# Editar config/tuya/devices.json con id, ip y local_key reales
```

Ver [docs/tuya.md](docs/tuya.md).

## Ejecutar servicios

```bash
# Un bridge específico
docker compose --profile govee up -d
docker compose --profile ewelink up -d
docker compose --profile tuya up -d

# Todos a la vez
./scripts/up.sh
```

## Logs

```bash
./scripts/logs.sh              # todos los bridges
./scripts/logs.sh govee2mqtt   # solo Govee
./scripts/logs.sh ewelink-mqtt
./scripts/logs.sh tuya-mqtt
```

## Actualizar

```bash
./scripts/update.sh
```

## Estructura

```
home-mqtt-bridges/
├── compose.yaml               # definición de los tres bridges
├── .env.example               # variables de entorno (copiar a .env)
├── containers/
│   ├── ewelink/               # Dockerfile + entrypoint para eWeLink
│   └── tuya/                  # Dockerfile + entrypoint para Tuya LAN
├── config/
│   └── tuya/
│       └── devices.example.json
├── scripts/
│   ├── check-env.sh           # validar variables de entorno
│   ├── logs.sh
│   ├── update.sh
│   └── up.sh
└── docs/
    ├── architecture.md
    ├── govee.md
    ├── ewelink.md
    ├── tuya.md
    ├── mqtt.md
    └── troubleshooting.md
```

## Despliegue en ZimaOS / CasaOS

```bash
cd /DATA/AppData
git clone git@github.com:TheMakunga/home-mqtt-bridges.git
cd home-mqtt-bridges
cp .env.example .env
# Editar .env
./scripts/up.sh
```

## Seguridad

- `.env` y `config/tuya/devices.json` están en `.gitignore` — **nunca se suben al repo**
- Permisos recomendados:

```bash
chmod 600 .env
chmod 600 config/tuya/devices.json
```

## Licencia

[MIT](LICENSE)
