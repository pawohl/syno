#!/usr/bin/env bash

set -euo pipefail

# Purpose: Update server certificates

# find certificates that might need an update
# cd / && find . -name "*.pem"
# check certificate
# openssl x509 -in cert.pem -text -noout

declare -a CERT_DIRS
CERT_DIRS=(\
	'/var/lib/docker/volumes/reverse_proxy_certs/_data/'
)

urlbase='https://cert.wohlpa.de/'
filebase='nimble'
base="${urlbase}${filebase}"

mkdir -p /tmp/syno-cert

wget -nv -O /tmp/nimble/cert.pem "${base}.cer"
wget -nv -O /tmp/nimble/chain.pem "${base}.chain"
wget -nv -O /tmp/nimble/fullchain.pem "${base}.fullchain"

# Check certificate we just fetched for validity
if openssl verify -untrusted '/tmp/nimble/chain.pem' '/tmp/nimble/cert.pem'
then
	echo "New certificate is valid. Installing."
else
	echo "Certificate from ${base}.cer appears to be invalid. Exit."
	exit 1
fi

for d in "${CERT_DIRS[@]}"
do
	if [ -d "$d" ]; then
		cp /tmp/nimble/cert.pem "$d/default-cert.pem"
		cp /tmp/nimble/chain.pem "$d/default-chain.pem"
		cp /tmp/nimble/fullchain.pem "$d/default.crt"
	fi
done

# reload services
set +e
cd /opt/reverse-proxy && docker compose exec reverse-proxy nginx -s reload
set -e

rm -r /tmp/nimble

echo "Done"
