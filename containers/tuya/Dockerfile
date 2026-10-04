FROM node:18-alpine

# Instalar bridge Tuya LAN durante el build
RUN apk add --no-cache git \
    && git clone --depth 1 https://github.com/TheAgentK/tuya-mqtt.git /app \
    && cd /app && npm ci --only=production \
    && apk del git

WORKDIR /app
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
