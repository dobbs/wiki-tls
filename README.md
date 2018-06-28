# wiki.localtest.me: a local Wiki farm and TLS proxy

See wiki site: https://local-farm.wiki.dbbs.co

Assuming you already have a local docker machine, and that you're
connected to The Internet...

### 1. launch the docker composition

``` bash
# launch the services
cp .env.example .env
docker-compose up -d

# find the password you'll need to edit pages
docker-compose run --rm farm \
  jq -r .admin .wiki/config.json
```

### 2. claim your first local wiki

Point your browser to https://localtest.me.  Your browser will present
a security warning because this is using a self-signed TLS
certificate.  Proceed with caution and then click the lock icon around
the bottom left corner to authenticate.  Use the admin password you
found in the logs from step 1.

### 3. create a few pages

Some really helpful places to start here: http://hello.ward.bay.wiki.org/

### 4. expand your farm

Point your browser to https://homestead.localtest.me and notice that
this is a new wiki, and already claimed by you, The Owner.  There are
several parts of this example which combine to make it extremely easy
to create new plots in the wiki farm:

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

### 5. experiment with plugins

The `admin` value in `config.json` is pre-configured to match the site
owner's secret.  With this in place, you can use [plugmatic] to
install plugins in your local wiki farm.  As of this writing the
plugins do not get installed in a persistent location in the
container.  The next reboot of the `farm` service will reset the
container to its original state without the plugins installed.

[plugmatic]: http://plugins.fed.wiki.org/about-plugmatic-plugin.html

### 6. experiment with image-transporter

This example also includes a copy of the [image-transporter] running
in an adjacent container: https://image-transporter.localtest.me.
Creating a wiki page that uses this transporter is left as an exercise
for the reader.

[image-transporter]: http://ward.asia.wiki.org/home.c2.com:4010/welcome-visitors

### 7. rename the generic owner

When you feel inclined, I've included a script in the docker image to
change the owner's name:

``` bash
docker-compose run --rm farm bin/set-owner-name YOUR NAME
# restart web to pick up these config changes
docker-compose restart web
```

### other admin tricks

#### backup the wiki

``` bash
docker run --rm -it \
  -v "wiki_localtest_me:/.wiki" \
  -v "$PWD:/dest" \
  alpine\
  sh -c 'tar zcf /dest/wiki.localtest.me.$(date +%a).tgz .wiki'
cp wiki.localtest.me.$(date +%a).tgz wiki.localtest.me.$(date +%b).tgz
cp wiki.localtest.me.$(date +%a).tgz wiki.localtest.me.$(date +%Y).tgz
```

The naming convention for backup files reduces risk of consuming disk
space.  This Thursday's backup will overwrite last Thursday's.  This
month's backup will overwrite last year's backup of the same month.

Day, month, and year names are vulnerable to differences in locale
inside the container (probably UTC) and outside the container
(probably local time).

#### restore a backup

``` bash
TARBALL=wiki.localtest.me.Jun.tgz
docker run --rm -it \
  -v "wiki_localtest_me:/.wiki" \
  -v "$PWD:/backup" \
  alpine tar zxf /backup/$TARBALL
```

#### One-time changes

If you are upgrading your local wiki, please refer to the following notes.

##### On 28 June 2018 the volume was renamed where wiki pages are saved.

``` bash
./migration/2018-06-28-rename-volumes
```

#### update all the related packages

``` bash
docker-compose exec farm npm install -g --prefix . wiki
docker-compose restart farm
```

These changes will survive a restart of the container, but if you stop
and remove the container, newly created containers will not include
these updates.

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
