# Base stage to download config
FROM alpine:latest AS builder

# Argument for the config URL (passed from GitHub Actions)
ARG XRAY_CONFIG_URL

# Install wget to download the config
RUN apk add --no-cache wget

# Download the config file
WORKDIR /tmp
RUN wget -O config.json "${XRAY_CONFIG_URL}"

# Final stage
FROM ghcr.io/xtls/xray-core:latest

# Copy the baked-in config
COPY --from=builder /tmp/config.json /etc/xray/config.json

ENV XRAY_LOCATION_ASSET=/usr/share/xray/
EXPOSE 7004

CMD ["run", "-c", "/etc/xray/config.json"]
