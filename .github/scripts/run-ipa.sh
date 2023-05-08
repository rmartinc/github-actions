#!/bin/bash

id -a
pwd
cat /etc/hosts

ipa-server-install --unattended --realm=EXAMPLE.TEST --ds-password=password --admin-password=password --idstart=60000

if ! grep -q ^ldap_user_extra_attrs /etc/sssd/sssd.conf; then
  sed -i '/ldap_tls_cacert/a ldap_user_extra_attrs = mail:mail, sn:sn, givenname:givenname, telephoneNumber:telephoneNumber' /etc/sssd/sssd.conf
fi
if ! grep -q ^user_attributes /etc/sssd/sssd.conf; then
  sed -i '/allowed_uids/a user_attributes = +mail, +telephoneNumber, +givenname, +sn' /etc/sssd/sssd.conf
fi

systemctl restart sssd
sss_cache -E

echo "auth    required   pam_sss.so" >>/etc/pam.d/keycloak
echo "account required   pam_sss.so" >>/etc/pam.d/keycloak

printf "%b" "password\n" | kinit admin
ipa group-add --desc='test group' testgroup
ipa user-add emily --first=Emily --last=Jones --email=emily@jones.com --random
ipa group-add-member testgroup --users=emily
ipa user-add bart --first=bart --last=bart --email= --random
ipa user-add david --first=david --last=david --random
kdestroy

ldapmodify -D "cn=Directory Manager" -w password <<EOF
dn: uid=emily,cn=users,cn=accounts,dc=example,dc=test
changetype: modify
replace: userpassword
userpassword: emili123

dn: uid=bart,cn=users,cn=accounts,dc=example,dc=test
changetype: modify
replace: userpassword
userpassword: bart123

dn: uid=david,cn=users,cn=accounts,dc=example,dc=test
changetype: modify
replace: userpassword
userpassword: david123

EOF

printf "%b" "password\n" | kinit admin
ipa user-disable david
kdestroy

./mvnw clean install

