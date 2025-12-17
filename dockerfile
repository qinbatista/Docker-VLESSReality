# Base stage to download config and prepare assets
FROM ghcr.io/xtls/xray-core:latest AS builder

# Argument for the config URL (passed from GitHub Actions)
ARG XRAY_CONFIG_URL

# Install wget to download the config
USER root
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
