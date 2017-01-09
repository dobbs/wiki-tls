# wiki farm with a tls proxy in a docker host

``` bash
# choose a fake domain name
NAME=wiki.dev

# install private names in /etc/hosts
DOCKER_HOST_IP=$(docker-machine ip your-docker-host)
echo "$DOCKER_HOST_IP  $NAME x.$NAME y.$NAME z.$NAME" | \
  sudo tee -a /etc/hosts

# launch the wiki and proxy
docker-compose up -d

# point your browser at the local wiki
open https://$NAME
```


# some notes I took along the way to this solution

### ./proxy/Caddyfile
It was surprisingly difficult to find this simple configuration.  It
didn't work to start the config with either of these two lines:

```
https:*wiki.dev
*wiki.dev:443
```

And it's important to specify `transparent` in the proxy config so
that the originally requested hostname is passed through to wiki
correctly.


### ./web/Dockerfile

using tini to solve the PID1 problem
using an application user instead of root to run wiki
