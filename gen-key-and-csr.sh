#!/usr/bin/env bash

# CSR from existing key
#  openssl req -new -sha256 -key san-synology.key -out san-synology.csr -config ...

# Create a new key
openssl req \
       -newkey rsa:2048 -nodes -keyout san-synology.key \
       -out san-synology.csr \
       -config <(
cat <<-EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C=DE
ST=Sachen-Anhalt
L=Halle
O=Pahlow Private Issue
OU=IT-Services
emailAddress=felix@wohlpa.de
CN = cp.pahl.ovh

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = wiki.wohlpa.de
DNS.2 = wiki.pahlow.ovh
DNS.3 = wiki.pahl.ovh
DNS.4 = cp.wohlpa.de
DNS.5 = cp.pahlow.ovh
DNS.6 = audio.pahl.ovh
DNS.7 = video.pahl.ovh
DNS.8 = photo.pahl.ovh
DNS.9 = surv.pahl.ovh
DNS.10 = odoo.pahl.ovh
DNS.11 = office.pahl.ovh
DNS.12 = file.pahl.ovh
DNS.13 = dl.pahl.ovh
DNS.14 = notes.pahl.ovh
DNS.15 = calendar.pahl.ovh
DNS.16 = carddav.pahl.ovh
DNS.17 = chat.pahl.ovh
DNS.18 = xd.pahl.ovh
DNS.19 = dns.pahl.ovh
DNS.20 = drive.pahl.ovh
DNS.21 = webdav.pahl.ovh
DNS.22 = cp.pahl.ovh

EOF
)

