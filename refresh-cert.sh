#!/usr/bin/env bash

set -euo pipefail

# Purpose: Update server certificates

# find certificates that might need an update
# cd / && find . -name "*.pem"
# check certificate
# openssl x509 -in cert.pem -text -noout

declare -a CERT_DIRS
CERT_DIRS=(\
	'/usr/local/etc/certificate/LogCenter/pkg-LogCenter/' \
	'/usr/local/etc/certificate/WebStation/vhost_280bb9ca-b884-43dd-a0f9-82fe551b95d6/' \
	'/usr/local/etc/certificate/CloudStation/CloudStationServer/' \
	'/usr/local/etc/certificate/SynologyDrive/SynologyDrive/' \
	'/usr/local/etc/certificate/DirectoryServer/slapd/' \
	'/usr/syno/etc/certificate/AppPortal/SynologyDrive/' \
	'/usr/syno/etc/certificate/AppPortal/SynologyMoments/' \
	'/usr/syno/etc/certificate/AppPortal/VideoStation/' \
	'/usr/syno/etc/certificate/AppPortal/AudioStation/' \
	'/usr/syno/etc/certificate/AppPortal/FileStation/' \
	'/usr/syno/etc/certificate/AppPortal/DownloadStation/' \
	'/usr/syno/etc/certificate/AppPortal/NoteStation/' \
	'/usr/syno/etc/certificate/smbftpd/ftpd/' \
	'/usr/syno/etc/certificate/system/FQDN/' \
	'/usr/syno/etc/certificate/system/default/'
)

urlbase='https://cert.wohlpa.de/'
filebase='san-synology'
base="${urlbase}${filebase}"

mkdir -p /tmp/syno-cert

wget -nv -O /tmp/syno-cert/cert.pem "${base}.cer"
wget -nv -O /tmp/syno-cert/chain.pem "${base}.chain"
wget -nv -O /tmp/syno-cert/fullchain.pem "${base}.fullchain"

# Check certificate we just fetched for validity
if openssl verify -untrusted '/tmp/syno-cert/chain.pem' '/tmp/syno-cert/cert.pem'
then
	echo "New certificate is valid. Installing."
else
	echo "Certificate from ${base}.cer appears to be invalid. Exit."
	exit 1
fi

for d in "${CERT_DIRS[@]}"
do
	if [ -d "$d" ]; then
		cp /tmp/syno-cert/cert.pem "$d"
		cp /tmp/syno-cert/chain.pem "$d"
		cp /tmp/syno-cert/fullchain.pem "$d"
	fi
done

# reload services
# synoservicecfg --list
set +e
synoservicectl --reload pkgctl-LogCenter
synoservicectl --reload pkgctl-WebStation
synoservicectl --reload pkgctl-CloudStation
synoservicectl --reload pkgctl-SynologyDrive
synoservicectl --reload pkgctl-SynologyMoments
synoservicectl --reload pkgctl-DirectoryServer
synoservicectl --reload pkgctl-VideoStation
synoservicectl --reload pkgctl-AudioStation
synoservicectl --reload pkgctl-FileStation
synoservicectl --reload pkgctl-DownloadStation
synoservicectl --reload pkgctl-NoteStation
synoservicectl --reload pkgctl-Git
synoservicectl --reload ftpd-ssl
synoservicectl --reload ldap-server
synoservicectl --reload nginx
set -e

rm -r /tmp/syno-cert

echo "Done"
