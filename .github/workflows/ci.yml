on:
  push:

jobs:
  test-project:
    name: test
    runs-on: ubuntu-latest
    container: fedora:latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Install needed packages
        run: |
          dnf install -y java-11-openjdk-devel nss-tools crypto-policies-scripts maven-openjdk11
          alternatives --set java java-11-openjdk.x86_64
          modutil -force -fips true -dbdir sql:/etc/pki/nssdb
          /usr/bin/fips-mode-setup --enable --no-bootcfg
          mkdir /tmp/build
          javac -d /tmp/build --patch-module java.base=.github/patch .github/patch/java/security/SystemConfigurator.java
        shell: bash
      - uses: actions/cache@v1
        with:
          path: ~/.m2/repository
          key: ${{ runner.os }}-maven-${{ hashFiles('**/pom.xml') }}
          restore-keys: |
            ${{ runner.os }}-maven-
      - name: Build
        run: mvn -B -fae clean install
