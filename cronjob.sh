#!/usr/bin/env bash

# purpose: Check certificate validity and re-request
#          certificate if invalid or about to expire
#
# usage: crontab -l
# ... /path/to/cronjob.sh /path/to/san-synology.cer /path/to/san-synology.chain > /var/www/status/cert-issue.log
#
# parameters:
# $1: Certificate
# $2: Chain

expirationDate=$(openssl x509 -enddate -noout -in "$1")
echo "$(date)"
echo "Certificate $1 will expire on $expirationDate."

if openssl verify -untrusted "$2" "$1"
then
  echo "Certificate is still valid."
else
  echo "Certificate is invalid. Re-issueing."
  exec /etc/cert/obtain.sh
fi

if openssl x509 -checkend 1382400 -noout -in "$1"
then
  echo "No renewal required."
else
  echo "Certificate expires in 16 days or less. Re-issueing."
  exec /etc/cert/obtain.sh
fi

