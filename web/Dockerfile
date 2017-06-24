FROM node:4-slim

RUN useradd --create-home app
WORKDIR /home/app
USER app
RUN npm install -g --prefix /home/app wiki@0.11.3

CMD ["/home/app/bin/wiki"]

EXPOSE 3000
