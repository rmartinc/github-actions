#!/bin/bash -x

# start the container for free-ipa
container=$(podman run --detach --rm -h ipa.example.test --sysctl net.ipv6.conf.all.disable_ipv6=0 --workdir /github/workspace -v "$JAVA_HOME":$JAVA_HOME" -v "$1":"/github/workspace" -v "$HOME/.m2":"/root/.m2" freeipa/freeipa-server:fedora-rawhide ipa-server-install --unattended --realm=EXAMPLE.TEST --ds-password=password --admin-password=password --idstart=60000)

# loop until the ipa server is started
sleep 30
line=$(podman logs $container | tail -1)
regexp="FreeIPA server configured."
while ! [[ "$line" =~ "$regexp" ]]; do
  sleep 30
  line=$(podman logs $container | tail -1)
done

podman exec $container .github/scripts/run-ipa-tests.sh
result=$?

podman stop $container

exit $result
