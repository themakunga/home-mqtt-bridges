# Arquitectura

## Diagrama

```
                    ┌─────────────────────┐
Govee ─────────────►│    govee2mqtt       │
(LAN + cloud)       │  ghcr.io/wez/...   │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
Sonoff ────────────►│   ewelink-mqtt      │
(LAN mDNS +         │  NickWaterton/...   │
 eWeLink cloud)     └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
Tuya / Nexxt ──────►│    tuya-mqtt        │
(LAN directa)       │  TheAgentK/...      │
                    └──────────┬──────────┘
                               │
                               ▼
                     ┌─────────────────┐
                     │  MQTT Broker    │   ← externo (Mosquitto)
                     │  $MQTT_HOST     │
                     └────────┬────────┘
                              │
                              ▼
                     ┌─────────────────┐
                     │ Home Assistant  │   ← externo
                     └─────────────────┘
```

## Red

Todos los bridges usan `network_mode: host` para permitir:

| Bridge | Protocolo | Motivo |
|--------|-----------|--------|
| govee2mqtt | UDP multicast | Descubrimiento LAN de dispositivos Govee |
| ewelink-mqtt | mDNS / Zeroconf | Descubrimiento LAN de dispositivos Sonoff |
| tuya-mqtt | TCP directo | Comunicación LAN con dispositivos Tuya |

## Topics MQTT

| Bridge | Prefijo |
|--------|---------|
| Govee | `govee/#` |
| Sonoff / eWeLink | `ewelink/#` |
| Tuya / Nexxt | `tuya/#` |
| HA Discovery | `homeassistant/#` |

## Servicios externos (fuera de este repo)

| Servicio | Rol |
|----------|-----|
| Mosquitto | Broker MQTT central |
| Home Assistant | Plataforma de automatización |
