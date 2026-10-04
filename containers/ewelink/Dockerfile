FROM python:3.11-slim

# Instalar dependencias durante el build — no en runtime
RUN apt-get update && apt-get install -y --no-install-recommends git \
    && pip install --no-cache-dir \
        aiohttp \
        paho-mqtt \
        zeroconf \
        voluptuous \
    && git clone --depth 1 https://github.com/NickWaterton/eWeLink-mqtt.git /app \
    && apt-get purge -y git \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
