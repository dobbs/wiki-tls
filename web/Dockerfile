FROM node:4-slim

RUN useradd --create-home app \
 && npm install -g wiki@0.11.3
WORKDIR /home/app
USER app

CMD ["wiki"]

EXPOSE 3000
