#!/usr/bin/env bash
set -euo pipefail

IMAGE="${IMAGE:-qinbatista/xray-reality:latest}"
NAME="${NAME:-xray-reality}"
PORT="${PORT:-443}"
NOFILE_SOFT="${NOFILE_SOFT:-262144}"
NOFILE_HARD="${NOFILE_HARD:-262144}"
CONNTRACK_MAX="${CONNTRACK_MAX:-1048576}"

if [[ "${EUID}" -ne 0 ]]; then
  echo "This script must run as root (use sudo)." >&2
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is not installed." >&2
  exit 1
fi

echo "Writing kernel tuning to /etc/sysctl.d/99-xray-reality.conf ..."
cat >/etc/sysctl.d/99-xray-reality.conf <<EOF
fs.file-max = 2097152
net.core.somaxconn = 65535
net.core.netdev_max_backlog = 16384
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.ip_local_port_range = 10240 65535
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_tw_reuse = 1
net.netfilter.nf_conntrack_max = ${CONNTRACK_MAX}
EOF

echo "Applying sysctl values ..."
sysctl --system >/dev/null

echo "Pulling image: ${IMAGE}"
docker pull "${IMAGE}"

if docker ps -a --format '{{.Names}}' | grep -Fxq "${NAME}"; then
  echo "Removing existing container: ${NAME}"
  docker rm -f "${NAME}" >/dev/null
fi

echo "Starting optimized container on ${PORT}->443 ..."
docker run -d \
  --restart=always \
  --name "${NAME}" \
  -p "${PORT}:443" \
  --ulimit "nofile=${NOFILE_SOFT}:${NOFILE_HARD}" \
  --log-driver json-file \
  --log-opt max-size=20m \
  --log-opt max-file=3 \
  "${IMAGE}" >/dev/null

echo "Container status:"
docker ps --filter "name=${NAME}" --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'

echo
echo "Applied settings:"
sysctl fs.file-max net.core.somaxconn net.ipv4.tcp_max_syn_backlog net.netfilter.nf_conntrack_max | sed 's/^/  /'
