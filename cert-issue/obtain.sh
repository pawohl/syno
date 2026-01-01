#!/usr/bin/env bash

# purpose: obtain a certificate from Let's Encrypt
#          using certbot-auto and a CSR

baseDir="/cert-data"
baseName="san-synology"
baseNameNimble="nimble"
base="$baseDir/$baseName"
baseNimble="$baseDir/$baseNameNimble"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# issue for synology
rm "$base.cer" "$base.chain" "$base.fullchain"

certbot -n --agree-tos \
      --email 'felix@wohlpa.de' \
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
      --manual-auth-hook "$SCRIPT_DIR/manual-auth-hook.pl"

cp "$base.cer" "$base.chain" "$base.fullchain" /syno-certs-public

# issue for nimble
rm "$baseNimble.cer" "$baseNimble.chain" "$baseNimble.fullchain"

certbot -n --agree-tos \
      --email 'felix@wohlpa.de' \
      -d ha.pahl.ovh \
      --manual --preferred-challenges dns certonly \
      --csr            "$baseNimble.csr" \
      --cert-path      "$baseNimble.cer" \
      --chain-path     "$baseNimble.chain" \
      --fullchain-path "$baseNimble.fullchain" \
      --manual-auth-hook "$SCRIPT_DIR/manual-auth-hook.pl"

cp "$baseNimble.cer" "$baseNimble.chain" "$baseNimble.fullchain" /syno-certs-public

