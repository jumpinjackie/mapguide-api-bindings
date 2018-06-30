#!/bin/bash
sudo yum install -y gcc make gcc-c++ wget git cmake java-1.7.0-openjdk java-1.7.0-openjdk-devel ant dos2unix openssh-server openldap-devel alsa-lib-devel pcre-devel unixODBC-devel libcom_err-devel krb5-devel openssl-devel mysql-devel postgresql-devel unixODBC
# To support Java test suite
sudo yum install -y ant-contrib
# epel extras
sudo yum --enablerepo=epel install -y p7zip p7zip-plugins
echo "JAVA_HOME=/usr/lib/jvm/java-openjdk" | sudo tee --append /etc/environment