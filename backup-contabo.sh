#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'
NEW_FOLDER=$(date +%Y-%m-%d)
HOST="contabo"
BASE="/volume1/backup/${HOST}"

echo "Backup ${HOST} server"
echo "Preparing by running script on server."
ssh -tt "${HOST}" backup.sh
echo "Copying files."
rsync \
	--archive \
	--rsync-path="sudo rsync" \
	--verbose \
	--compress \
	--link-dest "${BASE}/current" \
	"${HOST}:/opt" "${HOST}:/var/lib/docker/volumes" "${HOST}:/etc" "${HOST}:/home" \
	"${BASE}/incomplete/"
mv "${BASE}"/incomplete "${BASE}"/"${NEW_FOLDER}"
rm -f "${BASE}"/current
ln -s "${BASE}"/"${NEW_FOLDER}" "${BASE}"/current

