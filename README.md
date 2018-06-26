# syno
synology config and scripts

Synology NAS has Let's Encrypt Certificate retrieval built-in. However, automated renewal through Synology's certificate manager only works if the NAS is exposed to the Internet. In case, it is not, you need a workaround like these scripts and a DNS server that allows connections from Let's Encrypt or some kind of DNS API (OVH and other mature registrars offer that). These scripts are written for tinydns DNS server.

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
