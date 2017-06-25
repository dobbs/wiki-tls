FROM node:4-slim

RUN useradd --create-home app \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    jq
WORKDIR /home/app
RUN npm install -g --prefix . wiki@0.11.3
COPY bin bin
RUN chown -R app:app .
USER app
CMD ["/home/app/bin/wiki"]

EXPOSE 3000
