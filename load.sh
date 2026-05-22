#!/usr/bin/env bash

for f in reboot/*.xml; do
  echo
  n=$(basename $f .xml)
  echo "Loading $n..."
  curl -o /dev/null -X PUT http://localhost:8080/exist/restxq/v1/corpora/greek/plays/$n/tei \
    -u admin: \
    -H 'Content-Type: application/xml' \
    --data @$f
done
