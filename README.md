# wiki.localtest.me: a local Wiki farm, security_type=friends, and TLS proxy

Assuming you already have a local docker machine, and that you're
connected to The Internet...

### 1. launch the docker composition

``` bash
cp .env.example .env
docker-compose build
./bootstrap.sh
docker-compose up -d
```

### 2. claim your first local wiki

Point your browser to https://localtest.me.  Your browser will present
a security warning because this is using a self-signed TLS
certificate.  Proceed with caution and then click the lock icon around
the bottom left corner.

### 3. rename the randomly generated owner

When you claim the site the owner name is randomly generated.  I've
included a script in the docker image to change the owner's name:

``` bash
docker-compose run --rm web bin/set-owner-name YOUR NAME
# restart web to pick up these config changes
docker-compose restart web
```

### 4. create a few pages

Some really helpful places to start here: http://hello.ward.bay.wiki.org/

### 5. expand your farm

Point your browser to https://homestead.localtest.me and notice that
this is a new wiki, and already claimed by you.  There are several
parts of this example which combine to make it extremely easy to
create new plots in the wiki farm:

* [localtest.me](http://readme.localtest.me) is a public domain name
  which is configured so that all sub-domains point at `127.0.0.1`,
  the loopback address of your own computer.
* the `Caddyfile` we use also accepts requests for all domains and
  sub-domains and directs those to our `web` service where federated
  wiki runs.
* the `config.json` sets the wiki into farm mode and accepts requests
  for all sub-domains of localtest.me.

These three things together allow the creation of new wikis by simply
choosing a new sub-domain in our web browser.

### 6. experiment with plugins

The `admin` value in `config.json` must match the site owner's secret
in order for that owner to use [plugmatic].  There's another script in
the docker image to make that change:

``` bash
docker-compose run --rm web bin/set-admin-to-owner
# restart web to pick up these config changes
docker-compose restart web
```

With this in place, you can use plugmatic to install plugins in your
local wiki farm.  As of this writing the plugins do not get installed
in a persistent location in the container.  Next reboot of the `web`
service will reset the container to its original state without the
plugins installed.

[plugmatic]: http://plugins.fed.wiki.org/about-plugmatic-plugin.html

# Notes that maybe only apply to me

I have [The Docker Toolbox] installed on an older Mac which does not
have the necessary processor to run [Docker for Mac].  That means my
docker processes run in a virtual machine which is not `localhost` nor
`127.0.0.1` (nor `::1` for that matter).  And _that_ means the simple
brilliance of [localtest.me] needs a little extra fiddling to work
with my containerized experiments.

I set up an ad hoc reverse proxy to listen on `127.0.0.1` ports `:80`
and `:443` and forward the requests to the local virtual machine.  I
run the following commands in a separate window:

``` bash
brew install caddy # only need to do this once
IP=$(docker-machine active | xargs docker-machine ip)
printf "%s\n" :80, :443 'log stdout' 'errors stdout' 'tls self_signed' \
  "proxy / $IP { transparent }" | sudo caddy -conf stdin
```

[The Docker Toolbox]: https://www.docker.com/products/docker-toolbox
[Docker for Mac]: https://docs.docker.com/docker-for-mac/
[localtest.me]: https://http://readme.localtest.me/
