#!/bin/bash

dnf install -y java-17-openjdk-devel crypto-policies-scripts
fips-mode-setup --enable --no-bootcfg
if fips-mode-setup --is-enabled; then
  JAVA_HOME=/etc/alternatives/java_sdk_17 ./mvnw test -B -fae -pl testsuite
else
  exit 1
fi
