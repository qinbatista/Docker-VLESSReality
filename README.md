# Docker-VLESSReality

## Run Command

```bash
docker pull qinbatista/xray-reality && docker run -d --restart=always -p 443:443 --name xray-reality qinbatista/xray-reality:latest
```

## Optimized For High Concurrency (443)

Use the script below on your server to apply safe TCP/file-descriptor tuning and run the container with a high `nofile` limit:

```bash
sudo bash scripts/deploy_optimized.sh
```

Optional environment overrides:

```bash
sudo IMAGE=qinbatista/xray-reality:latest NAME=xray-reality PORT=443 \
NOFILE_SOFT=262144 NOFILE_HARD=262144 bash scripts/deploy_optimized.sh
```

