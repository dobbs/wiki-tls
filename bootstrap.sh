#!/bin/bash -eu
set -o pipefail

readonly COMPOSE_DIR=$( cd $(dirname $0); pwd )

main() {
    create-environment
    if [ -n "${NAME_OF_MACHINE_TO_CREATE:-}" ]; then
      create-machine
      create-docker-environment
    fi

    create-named-volumes
    open-portal-to-named-volumes
    install-configs-in-named-volumes
    close-portal-to-named-volumes
}

create-environment() {
    source $COMPOSE_DIR/.env
    if [ -n "${NAME_OF_MACHINE_TO_CREATE:-}" ]; then
        echo "Will create docker host named '$NAME_OF_MACHINE_TO_CREATE', unless it already exists."
    fi
}

create-machine() {
    machine-exists || {
        docker-machine create --driver virtualbox $NAME_OF_MACHINE_TO_CREATE
    }
}

machine-exists() {
    docker-machine ls -q | grep -q "$NAME_OF_MACHINE_TO_CREATE"
}

create-docker-environment() {
    eval $(docker-machine env $NAME_OF_MACHINE_TO_CREATE)
}

create-named-volumes() {
    docker volume create --name wiki.localtest.me
}

open-portal-to-named-volumes() {
    docker run --name ping -d \
           -v wiki.localtest.me:/dot-wiki \
           buildpack-deps:jessie-curl ping -i 60 localhost
}

install-configs-in-named-volumes() {
    cd $COMPOSE_DIR
    docker cp dot-wiki/config.json ping:/dot-wiki/config.json
    docker-compose run --rm --user root -e TINI_SUBREAPER=1 web chown -R app:app .wiki
}

close-portal-to-named-volumes() {
    docker rm -f ping
}

main
