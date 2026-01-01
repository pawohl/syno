#!/usr/bin/env bash

# CSR from existing key
#  openssl req -new -sha256 -key san-synology.key -out san-synology.csr -config ...

# Create a new key
openssl req \
       -newkey rsa:4096 -nodes -keyout nimble.key \
       -out nimble.csr \
       -config <(
cat <<-EOF
[req]
default_bits = 4096
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
CN = ha.pahl.ovh

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = ha.pahl.ovh

EOF
)

