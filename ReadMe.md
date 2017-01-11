# Wiki farm, security_type=friends, and TLS proxy

``` bash
# choose fake domain and subdomain names
NAME=wiki.dev
SUBNAMES="x.$NAME y.$NAME z.$NAME"

# install private names in /etc/hosts
DOCKER_HOST_IP=$(docker-machine ip your-docker-host)
echo "$DOCKER_HOST_IP  $NAME $SUBNAMES" | sudo tee -a /etc/hosts

# launch the wiki and proxy
docker-compose up -d

# point your browser at the local wiki, and claim the site
# expect to see the usual self-signed cert security warnings from the browser
open https://$NAME

# point your browser at a sub-wiki, and claim that site too
open https://x.$NAME
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

* using tini to solve the PID1 problem
* using an application user instead of root to run wiki
