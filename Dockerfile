FROM certbot/certbot

RUN apk add --no-cache perl bash

COPY cert-issue /cert-issue
COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

