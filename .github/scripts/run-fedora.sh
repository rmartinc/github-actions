#!/bin/bash

dnf install -y java-11-openjdk-devel nss-tools crypto-policies-scripts maven-openjdk11
fips-mode-setup --enable --no-bootcfg
fips-mode-setup --check
JAVA_HOME=/etc/alternatives/java_sdk_11 mvn test -B -fae -pl testsuite
