#!/bin/bash

pwd
ls -la
dnf install -y java-11-openjdk-devel nss-tools crypto-policies-scripts maven-openjdk11
fips-mode-setup --enable --no-bootcfg
fips-mode-setup --check
mvn -B -fae clean install
