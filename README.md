# Docker-VLESSReality

## Run Command

```bash
docker pull qinbatista/xray-reality && docker run -d --restart=always -p 7004:7004 --name xray-reality qinbatista/xray-reality:latest
```

## Client Configuration (Shadowrocket)

Add a new server and select **VLESS**:

- **Address**: `Your_Server_IP`
- **Port**: `7004`
- **UUID**: `57810ed3-0608-4f96-95a0-5c9237400549`
- **Flow**: `xtls-rprx-vision`
- **Network**: `tcp`
- **Security**: `reality`
- **PBK**: `g72ehB9XFVH3vbJ4UzYUvjNF-tvPyS0RGftHiDmwBi4`
- **SNI**: `www.microsoft.com`
- **SID**: `a7814ad56ccfb712`

## Server Configuration Template (config.json)

Upload this to your `XRAY_CONFIG_URL`:

```json
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": 7004,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "57810ed3-0608-4f96-95a0-5c9237400549",
            "flow": "xtls-rprx-vision"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "tcp",
        "security": "reality",
        "realitySettings": {
          "show": false,
          "dest": "www.microsoft.com:443",
          "serverNames": [
            "www.microsoft.com",
            "www.bing.com"
          ],
          "privateKey": "cJmHDfMpMrNQQEHJfmA7U-WlVkwoMCBmKIAxOsjSxkY",
          "shortIds": [
            "a7814ad56ccfb712"
          ]
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "tag": "blocked"
    }
  ]
}
```
