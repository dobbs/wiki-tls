FROM node:4-slim

ENV TINI_VERSION v0.13.2
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /tini.asc
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 \
 && gpg --verify /tini.asc \
 && chmod +x /tini

RUN npm install -g wiki

ARG user=app
ARG group=app
ARG home=/home/app
# controlling uid & gid for 'app' account below:
#
#   Docker host was created with docker-machine.  Here, the
#   container's 'app' account has the same ids as the host's 'docker'
#   account.  Mounted volumes will have correct ownership and
#   permissions.  If you encounter problems writing file inside the
#   container, there is some chance these values do not match the IDs
#   on your docker host.
ARG uid=1000
ARG gid=50

RUN groupadd -g ${gid} ${group} \
    && useradd -d "${home}" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

WORKDIR $home

USER app

ENTRYPOINT ["/tini", "--"]
CMD ["wiki", "--autoseed", "--farm"]

EXPOSE 3000
