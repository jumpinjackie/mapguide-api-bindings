#!/bin/bash
# Set bash as the default shell
echo "dash    dash/sh boolean false" | sudo debconf-set-selections
sudo dpkg-reconfigure --frontend=noninteractive dash
# Guard against (http://askubuntu.com/questions/41605/trouble-downloading-updates-due-to-a-hash-sum-mismatch-error)
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get update
sudo apt-get install -y zip build-essential openjdk-7-jdk git wget cmake dos2unix p7zip-full libpcre3-dev
# To support Java test suite
sudo apt-get install -y ant-contrib
# Buildpack deps. Need xerces so we have its headers, which is needed by string out typemaps for .net. Buildpack does not include xerces headers because
# they have been "configure"'d for Win32
sudo apt-get install -y libxerces-c-dev
# Install .net Core SDK
wget -q https://packages.microsoft.com/config/ubuntu/14.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get install -y apt-transport-https && sudo apt-get update && sudo apt-get install -y dotnet-sdk-2.1
# Register JAVA_HOME
echo "JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64" | sudo tee --append /etc/environment