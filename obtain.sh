#!/usr/bin/env bash

# purpose: obtain a certificate from Let's Encrypt
#          using certbot-auto and a CSR

baseDir="/etc/cert"
baseName="san-synology"
base="$baseDir/$baseName"

rm "$base.cer" "$base.chain" "$base.fullchain"

/opt/certbot-auto -n --agree-tos \
      -d wiki.wohlpa.de -d wiki.pahlow.ovh -d wiki.pahl.ovh \
      -d cp.wohlpa.de -d cp.pahlow.ovh -d cp.pahl.ovh \
      -d audio.pahl.ovh -d video.pahl.ovh -d photo.pahl.ovh \
      -d surv.pahl.ovh -d odoo.pahl.ovh -d office.pahl.ovh \
      -d file.pahl.ovh -d dl.pahl.ovh -d notes.pahl.ovh \
      -d notes.pahl.ovh -d calendar.pahl.ovh -d carddav.pahl.ovh \
      -d chat.pahl.ovh -d xd.pahl.ovh -d dns.pahl.ovh \
      -d drive.pahl.ovh -d webdav.pahl.ovh -d moments.pahl.ovh \
      --manual --preferred-challenges dns certonly \
      --csr            "$base.csr" \
      --cert-path      "$base.cer" \
      --chain-path     "$base.chain" \
      --fullchain-path "$base.fullchain" \
      --manual-auth-hook "$baseDir/manual-auth-hook.pl" \
      --manual-public-ip-logging-ok

cp "$base.cer" "$base.chain" "$base.fullchain" /var/www/static/cert.wohlpa.de/

