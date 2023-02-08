#!/bin/bash

find /github/home
dnf install -y java-11-openjdk-devel nss-tools crypto-policies-scripts maven-openjdk11
fips-mode-setup --enable --no-bootcfg
fips-mode-setup --check
./mvnw test -B -fae -pl testsuite
