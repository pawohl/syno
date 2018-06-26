# syno
synology config and scripts

Synology NAS has Let's Encrypt Certificate retrieval built-in. However, this only works if the NAS is exposed to the Internet.

## refresh-cert.sh

* Execution host: NAS devices
* Executed by: Task Scheduler (Synology NAS -> Control Panel -> System)
* Purpose: Obtains the latest certificates from public server

## cronjob.sh

* Execution host: Public server
* Executed by: cron daemon
* Purpose: Check certificate validity including chain and decide if a new certificate should be requested from Let's Encrypt

## gen-key-and-csr.sh

* Execution host: Public server
* Executed by: - (manual execution)
* Purpose: Create new keys or CSRs

## manual-auth-hook.pl

* Execution host: Public server
* Executed by: certbot
* Purpose: Set up the Let's Encrypt DNS challenges for tinydns/djbdns

## obtain.sh

* Execution host: Public server
* Executed by: cronjob.sh
* Purpose: Obtain new certificate (including chain) from Let's Encrypt
