#!/bin/bash -x

set -o pipefail
DOCKER=podman

# start the container for free-ipa
container=$($DOCKER run --detach --rm -h ipa.example.test --sysctl net.ipv6.conf.all.disable_ipv6=0 --workdir /github/workspace -v "$1":"/github/workspace" -v "$HOME/.m2":"/root/.m2" freeipa/freeipa-server:fedora-rawhide ipa-server-install --unattended --realm=EXAMPLE.TEST --ds-password=password --admin-password=password --idstart=60000)

# loop until the ipa server is started
sleep 30
line=$($DOCKER logs $container | tail -1)
while [[ "$line" != "FreeIPA server configured." ]]; do
  sleep 30
  line=$($DOCKER logs $container | tail -1)
  if [ $? -ne 0 ]; then
    exit 1
  fi
done

$DOCKER exec -e "JAVA_HOME" $container .github/scripts/run-ipa-tests.sh
result=$?

$DOCKER stop $container

exit $result
