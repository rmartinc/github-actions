#!/bin/bash

set -o pipefail
DOCKER=podman

# start the container for free-ipa
container=$($DOCKER run --detach --rm -h ipa.example.test --sysctl net.ipv6.conf.all.disable_ipv6=0 --workdir /github/workspace -v "$1":"/github/workspace" -v "$HOME/.m2":"/root/.m2" freeipa/freeipa-server:fedora-rawhide ipa-server-install --unattended --realm=EXAMPLE.TEST --ds-password=password --admin-password=password --idstart=60000)

# loop until the ipa server is started
sleep 30
line=$($DOCKER logs ipa-server | tail -1)
regexp="FreeIPA server configured.|FreeIPA server started."
while ! [[ "$line" =~ $regexp ]]; do
  sleep 30
  line=$($DOCKER logs ipa-server | tail -1)
  if [ $? -ne 0 ]; then
    exit 1
  fi
done

new_install="false"
if [[ $line == "FreeIPA server configured." ]]; then
  new_install="true"
fi
$DOCKER exec ipa-server .github/scripts/run-ipa-tests.sh $new_install
result=$?

$DOCKER stop ipa-server

exit $result
