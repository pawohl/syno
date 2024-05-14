#!/usr/bin/env bash
set -x

pid=0

# SIGTERM-handler
term_handler() {
  if [ $pid -ne 0 ]; then
    kill -SIGTERM "$pid"
    wait "$pid"
  fi
  exit 143; # 128 + 15 -- SIGTERM
}

trap 'kill ${!}; term_handler' SIGTERM

# sleep for 12h = 43200s
sleep 43200 && cd /cert-data && /cert-issue/cronjob.sh san-synology.cer san-synology.chain &

pid="$!"

# wait until pid ends
echo "Waiting for $pid to end"
while true
do
  tail -f /dev/null & wait "$pid"
done

