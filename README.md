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

Point your browser to https://localtest.me.  Your browser will warn
present a security warning because this is using a self-signed TLS
certificate.  Proceed with caution and then click the lock icon around
the bottom left corner.

### 3. rename the randomly generated owner

This part is still more fiddly than I'd like.  When you claim the site
the owner name is randomly generated.  This trick will let you choose
your own name:

``` bash
docker-compose run --rm web \
  perl -pi -e 's/RANDOM-NAME/CORRECT-NAME/' \
  .wiki/localtest.me.owner.json

# restart wiki to pick up that change
docker-compose restart web
```

### 4. create a few pages

Some really helpful places to start here: http://hello.ward.bay.wiki.org/

### 5. expand your farm

Point your browser to https://homestead.localtest.me and notice that
this is a new wiki, and already claimed by you.  (Not all wiki's do
that particular trick, and we'll explain the magic later.)
