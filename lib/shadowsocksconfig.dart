

 Map rawConfig = {
   "dns": {
     "hosts": {
       "domain:googleapis.cn": "googleapis.com"
     },
     "servers": [
       "8.8.8.8"
     ]
   },
   "inbounds": [
     {
       "listen": "127.0.0.1",
       "port": 10808,
       "protocol": "socks",
       "settings": {
         "auth": "noauth",
         "udp": true,
         "userLevel": 8
       },
       "sniffing": {
         "destOverride": [
           "http",
           "tls"
         ],
         "enabled": false
       },
       "tag": "socks"
     },
     {
       "listen": "127.0.0.1",
       "port": 10809,
       "protocol": "http",
       "settings": {
         "userLevel": 8
       },
       "tag": "http"
     }
   ],
   "log": {
     "loglevel": "warning"
   },
   "outbounds": [
     {
       "mux": {
         "concurrency": -1,
         "enabled": false
       },
       "protocol": "shadowsocks",
       "settings": {
         "servers": [
           {
             "address": "sg01.proxysocks.xyz",
             "level": 8,
             "method": "chacha20-ietf-poly1305",
             "password": "MWRkZ",
             "port": 8388
           }
         ]
       },
       "streamSettings": {
         "network": "tcp",
         "security": "none"
       },
       "tag": "proxy"
     },
     {
       "protocol": "freedom",
       "settings": {},
       "tag": "direct"
     },
     {
       "protocol": "blackhole",
       "settings": {
         "response": {
           "type": "http"
         }
       },
       "tag": "block"
     }
   ],
   "policy": {
     "levels": {
       "8": {
         "connIdle": 30,
         "downlinkOnly": 1,
         "handshake": 4,
         "uplinkOnly": 1
       }
     },
     "system": {
       "statsOutboundUplink": false,
       "statsOutboundDownlink": false
     }
   },
   "routing": {
     "domainStrategy": "",
     "rules": []
   },
   "stats": {}
 };