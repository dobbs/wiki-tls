FROM abiosoft/caddy:0.10.2

RUN apk add --no-cache libcap \
 && setcap 'cap_net_bind_service=+ep' /usr/bin/caddy \
 && addgroup -S -g 8888 caddy \
 && adduser -S -u 8888 -D -H caddy \
 && mkdir -p /etc/proxy
ADD Caddyfile /etc/proxy/Caddyfile
USER caddy
VOLUME /etc/proxy
# ENTRYPOINT from abiosoft/caddy: ["/usr/bin/caddy"]
CMD ["--conf", "/etc/proxy/Caddyfile", "--log", "stdout"]
